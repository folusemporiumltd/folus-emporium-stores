-- The app verifies shared administrators before using the Store service credential.
CREATE OR REPLACE FUNCTION public.admin_moderate_product_review(p_review_id uuid, p_status text, p_admin_note text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if coalesce(auth.jwt()->>'role','') <> 'service_role' and (auth.uid() is null or not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) then raise exception 'Admin access required.'; end if;
  if p_status not in ('approved','rejected') then raise exception 'Invalid moderation status.'; end if;
  update public.product_reviews set status=p_status,admin_note=nullif(trim(coalesce(p_admin_note,'')),''),moderated_at=now(),moderated_by=case when auth.jwt()->>'role'='service_role' then null else auth.uid() end,updated_at=now() where id=p_review_id;
  return found;
end;
$function$
;
CREATE OR REPLACE FUNCTION public.list_admin_product_reviews()
 RETURNS TABLE(id uuid, product_id uuid, product_name text, order_id uuid, user_id uuid, customer_name text, customer_email text, rating smallint, title text, review text, status text, admin_note text, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if coalesce(auth.jwt()->>'role','') <> 'service_role' and (auth.uid() is null or not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) then raise exception 'Admin access required.'; end if;
  return query select r.id,r.product_id,p.name,r.order_id,r.user_id,r.reviewer_name,o.email,r.rating,r.title,r.review,r.status,r.admin_note,r.created_at,r.updated_at
  from public.product_reviews r join public.products p on p.id=r.product_id join public.orders o on o.id=r.order_id
  order by case r.status when 'pending' then 0 when 'approved' then 1 else 2 end,r.created_at desc;
end;
$function$
;
