-- Store data remains in this project while administrator identity is verified
-- against the main Folus project by the Next.js server before using service role.
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path to 'public'
as $$
  select coalesce(auth.jwt()->>'role' = 'service_role', false)
    or exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;
