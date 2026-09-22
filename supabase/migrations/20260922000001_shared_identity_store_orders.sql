-- Shared identity IDs are stored as references without duplicating account credentials.
create table if not exists public.store_customers (
  id uuid primary key,
  email text not null,
  full_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.store_customers enable row level security;
revoke all on public.store_customers from anon, authenticated;
grant all on public.store_customers to service_role;
alter table public.orders drop constraint if exists orders_user_id_fkey;
alter table public.orders add constraint orders_user_id_fkey foreign key (user_id) references public.store_customers(id) on delete restrict;
CREATE OR REPLACE FUNCTION public.create_checkout_order_v2(p_user_id uuid, p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text DEFAULT 'paystack'::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ declare v_order_id uuid:=gen_random_uuid(); v_subtotal numeric:=0; v_fee numeric:=0; v_item jsonb; v_product record; v_variant record; v_qty int; v_variant_id uuid; v_existing uuid; begin if coalesce(auth.jwt()->>'role','') <> 'service_role' then raise exception 'Trusted Store server required'; end if; if coalesce(trim(p_email),'')='' then raise exception 'Email is required'; end if; if p_payment_method not in ('paystack','pay_after_delivery') then raise exception 'Invalid payment method'; end if; if jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Order must contain at least one item'; end if; v_fee:=case lower(trim(coalesce(p_delivery_zone,''))) when 'ibadan' then 2000 when 'lagos' then 5000 when 'other' then 8000 else null end; if v_fee is null then raise exception 'Select a valid delivery location'; end if; if p_payment_method='paystack' and coalesce(trim(p_payment_reference),'')='' then raise exception 'Payment reference is required'; end if; if coalesce(trim(p_payment_reference),'')<>'' then select id into v_existing from public.orders where payment_reference=p_payment_reference and user_id=p_user_id limit 1; if v_existing is not null then return v_existing; end if; end if; for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.stock_quantity,pv.is_active,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id and p.is_active=true and p.id=(v_item->>'id')::uuid and pv.price>0 for update of pv; if not found or not v_variant.is_active or v_variant.stock_quantity<v_qty then raise exception 'Selected product size is unavailable'; end if; v_subtotal:=v_subtotal+v_variant.price*v_qty; else select id,name,price,stock_quantity,is_active into v_product from public.products where id=(v_item->>'id')::uuid for update; if not found or not v_product.is_active or v_product.stock_quantity<v_qty then raise exception 'Product is unavailable'; end if; v_subtotal:=v_subtotal+v_product.price*v_qty; end if; end loop; insert into public.orders(id,user_id,customer_name,email,status,payment_status,payment_reference,subtotal,delivery_fee,total,delivery_address,delivery_zone,phone,payment_method) values(v_order_id,p_user_id,nullif(trim(p_customer_name),''),trim(p_email),'pending','pending',nullif(trim(p_payment_reference),''),v_subtotal,v_fee,v_subtotal+v_fee,nullif(trim(p_delivery_address),''),lower(trim(p_delivery_zone)),nullif(trim(p_phone),''),p_payment_method); for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.size_grams,pv.size_label,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id; insert into public.order_items(order_id,product_id,variant_id,product_name,unit_price,quantity,size_grams,size_label) values(v_order_id,v_variant.product_id,v_variant.id,v_variant.name,v_variant.price,v_qty,v_variant.size_grams,v_variant.size_label); else select id,name,price into v_product from public.products where id=(v_item->>'id')::uuid; insert into public.order_items(order_id,product_id,product_name,unit_price,quantity) values(v_order_id,v_product.id,v_product.name,v_product.price,v_qty); end if; end loop; return v_order_id; end; $function$
;
CREATE OR REPLACE FUNCTION public.confirm_pay_after_delivery_order(p_order_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  o public.orders;
  x record;
  v_stock integer;
begin
  select * into o from public.orders where id=p_order_id for update;
  if not found then raise exception 'Order not found'; end if;
  if coalesce(auth.jwt()->>'role','') <> 'service_role' then raise exception 'Trusted Store server required'; end if;
  if o.payment_method<>'pay_after_delivery' then raise exception 'Invalid payment method'; end if;
  if o.status<>'pending' then return o.id; end if;

  if o.inventory_allocated_at is null or o.inventory_released_at is not null then
    for x in select variant_id,product_id,quantity,product_name from public.order_items where order_id=o.id loop
      if x.variant_id is not null then
        select stock_quantity into v_stock from public.product_variants where id=x.variant_id for update;
        if not found then raise exception 'Variant not found'; end if;
        if v_stock<x.quantity then raise exception 'Insufficient stock for %',coalesce(x.product_name,'product'); end if;
      else
        select stock_quantity into v_stock from public.products where id=x.product_id for update;
        if not found then raise exception 'Product not found'; end if;
        if v_stock<x.quantity then raise exception 'Insufficient stock for %',coalesce(x.product_name,'product'); end if;
      end if;
    end loop;
    for x in select variant_id,product_id,quantity from public.order_items where order_id=o.id loop
      if x.variant_id is not null then update public.product_variants set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.variant_id;
      else update public.products set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.product_id; end if;
    end loop;
    update public.orders set inventory_allocated_at=now(),inventory_released_at=null where id=o.id;
  end if;

  update public.orders set status='processing',updated_at=now() where id=o.id;
  return o.id;
end;
$function$
;
-- Review authors use the same shared identity ID as their Store orders.
alter table public.product_reviews drop constraint if exists product_reviews_user_id_fkey;
alter table public.product_reviews add constraint product_reviews_user_id_fkey foreign key (user_id) references public.store_customers(id) on delete cascade;
