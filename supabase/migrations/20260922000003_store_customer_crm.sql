-- CRM uses only Store customers and orders.
CREATE OR REPLACE FUNCTION public.list_admin_customer_crm()
 RETURNS TABLE(user_id uuid, full_name text, email text, phone text, role text, joined_at timestamp with time zone, total_orders bigint, paid_orders bigint, delivered_orders bigint, lifetime_spend numeric, last_order_at timestamp with time zone, last_order_status text, last_payment_status text, last_delivery_address text, last_delivery_zone text, newsletter_status text, customer_type text, recent_orders jsonb)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;

  return query
  with order_stats as (
    select
      o.user_id,
      count(*) as total_orders,
      count(*) filter (where o.payment_status = 'paid' and o.status <> 'cancelled') as paid_orders,
      count(*) filter (where o.status = 'delivered') as delivered_orders,
      coalesce(sum(o.total) filter (where o.payment_status = 'paid' and o.status <> 'cancelled'), 0) as lifetime_spend,
      min(o.created_at) as first_order_at,
      max(o.created_at) as last_order_at
    from public.orders o
    where o.user_id is not null
    group by o.user_id
  )
  select
    p.id as user_id,
    coalesce(nullif(p.full_name,''), nullif(latest.customer_name,''), split_part(p.email,'@',1)) as full_name,
    p.email::text as email,
    nullif(latest.phone,'') as phone,
    'customer'::text as role,
    p.created_at as joined_at,
    coalesce(os.total_orders,0)::bigint,
    coalesce(os.paid_orders,0)::bigint,
    coalesce(os.delivered_orders,0)::bigint,
    coalesce(os.lifetime_spend,0)::numeric,
    os.last_order_at,
    latest.status as last_order_status,
    latest.payment_status as last_payment_status,
    latest.delivery_address as last_delivery_address,
    latest.delivery_zone as last_delivery_zone,
    coalesce(ns.status,'not_subscribed') as newsletter_status,
    case when coalesce(os.total_orders,0) >= 2 then 'Returning' when coalesce(os.total_orders,0) = 1 then 'New' else 'Registered' end as customer_type,
    coalesce(ro.orders,'[]'::jsonb) as recent_orders
  from public.store_customers p
  left join order_stats os on os.user_id = p.id
  left join lateral (
    select o.customer_name,o.phone,o.status,o.payment_status,o.delivery_address,o.delivery_zone
    from public.orders o
    where o.user_id = p.id
    order by o.created_at desc
    limit 1
  ) latest on true
  left join lateral (
    select n.status
    from public.newsletter_subscribers n
    where n.user_id = p.id or lower(n.email) = lower(p.email)
    order by n.updated_at desc
    limit 1
  ) ns on true
  left join lateral (
    select jsonb_agg(jsonb_build_object(
      'id', q.id,
      'created_at', q.created_at,
      'status', q.status,
      'payment_status', q.payment_status,
      'payment_method', q.payment_method,
      'total', q.total,
      'payment_reference', q.payment_reference,
      'items', q.items
    ) order by q.created_at desc) as orders
    from (
      select o.id,o.created_at,o.status,o.payment_status,o.payment_method,o.total,o.payment_reference,
        coalesce((select jsonb_agg(jsonb_build_object('product_name',oi.product_name,'size_label',oi.size_label,'quantity',oi.quantity,'line_total',oi.line_total) order by oi.product_name) from public.order_items oi where oi.order_id=o.id),'[]'::jsonb) as items
      from public.orders o
      where o.user_id = p.id
      order by o.created_at desc
      limit 10
    ) q
  ) ro on true
  order by coalesce(os.last_order_at,p.created_at) desc;
end;
$function$
;
