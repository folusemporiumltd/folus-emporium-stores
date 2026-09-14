SET LOCAL check_function_bodies = off;

SET LOCAL search_path = public, extensions;

CREATE TABLE public."profiles" (
id uuid NOT NULL,
full_name text,
phone text,
role text DEFAULT 'customer'::text NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."categories" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
name text NOT NULL,
slug text NOT NULL,
description text,
image_url text,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."products" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
category_id uuid,
name text NOT NULL,
slug text NOT NULL,
description text,
price numeric(12,2) NOT NULL,
compare_at_price numeric(12,2),
stock_quantity integer DEFAULT 0 NOT NULL,
image_url text,
is_active boolean DEFAULT true NOT NULL,
featured boolean DEFAULT false NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
default_size_grams integer DEFAULT 500 NOT NULL
);

CREATE TABLE public."order_items" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
order_id uuid NOT NULL,
product_id uuid,
product_name text NOT NULL,
unit_price numeric(12,2) NOT NULL,
quantity integer NOT NULL,
line_total numeric(12,2) GENERATED ALWAYS AS ((unit_price * (quantity)::numeric)) STORED,
variant_id uuid,
size_grams integer,
size_label text
);

CREATE TABLE public."product_variants" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
product_id uuid NOT NULL,
size_grams integer NOT NULL,
size_label text NOT NULL,
price numeric NOT NULL,
stock_quantity integer DEFAULT 0 NOT NULL,
sku text,
is_active boolean DEFAULT true NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
reorder_threshold integer DEFAULT 5 NOT NULL
);

CREATE TABLE public."storefront_content" (
id boolean DEFAULT true NOT NULL,
config jsonb NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."coupons" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
code text NOT NULL,
description text,
discount_type text NOT NULL,
discount_value numeric NOT NULL,
minimum_order numeric DEFAULT 0 NOT NULL,
max_uses integer,
used_count integer DEFAULT 0 NOT NULL,
starts_at timestamp with time zone,
expires_at timestamp with time zone,
is_active boolean DEFAULT true NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."newsletter_subscribers" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
user_id uuid,
email text NOT NULL,
full_name text,
status text DEFAULT 'subscribed'::text NOT NULL,
source text DEFAULT 'website'::text NOT NULL,
consent_at timestamp with time zone DEFAULT now() NOT NULL,
unsubscribed_at timestamp with time zone,
unsubscribe_token uuid DEFAULT gen_random_uuid() NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
brevo_synced_at timestamp with time zone,
brevo_sync_error text,
welcome_email_sent_at timestamp with time zone,
welcome_email_error text
);

CREATE TABLE public."blog_posts" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
title text NOT NULL,
slug text NOT NULL,
category text,
excerpt text,
content text NOT NULL,
is_published boolean DEFAULT true NOT NULL,
published_at timestamp with time zone,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
featured_image_url text
);

CREATE TABLE public."content_pages" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
title text NOT NULL,
slug text NOT NULL,
menu_location text DEFAULT 'none'::text NOT NULL,
excerpt text,
content text DEFAULT ''::text NOT NULL,
is_published boolean DEFAULT false NOT NULL,
display_order integer DEFAULT 0 NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
featured_image_url text
);

CREATE TABLE public."company_pages" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
page_key text NOT NULL,
eyebrow text,
title text NOT NULL,
intro text,
content text,
secondary_title text,
secondary_content text,
is_published boolean DEFAULT true NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."orders" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
user_id uuid,
status text DEFAULT 'pending'::text NOT NULL,
payment_status text DEFAULT 'pending'::text NOT NULL,
payment_reference text,
subtotal numeric(12,2) DEFAULT 0 NOT NULL,
delivery_fee numeric(12,2) DEFAULT 0 NOT NULL,
total numeric(12,2) DEFAULT 0 NOT NULL,
delivery_address text,
phone text,
notes text,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
email text,
customer_name text,
coupon_code text,
discount_amount numeric DEFAULT 0 NOT NULL,
delivery_zone text,
payment_method text DEFAULT 'paystack'::text NOT NULL,
inventory_allocated_at timestamp with time zone,
inventory_released_at timestamp with time zone
);

CREATE TABLE public."homepage_sections" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
section_key text NOT NULL,
section_name text NOT NULL,
eyebrow text,
title text,
content text,
button_label text,
button_url text,
display_order integer DEFAULT 0 NOT NULL,
is_published boolean DEFAULT true NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."newsletter_campaigns" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
subject text NOT NULL,
preview_text text,
body_html text NOT NULL,
status text DEFAULT 'draft'::text NOT NULL,
sent_count integer DEFAULT 0 NOT NULL,
sent_at timestamp with time zone,
created_by uuid,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."stock_movements" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
variant_id uuid NOT NULL,
product_id uuid NOT NULL,
old_quantity integer NOT NULL,
new_quantity integer NOT NULL,
quantity_change integer NOT NULL,
changed_by uuid,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."newsletter_events" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
resend_event_id text,
resend_email_id text,
event_type text NOT NULL,
recipient_email text,
subject text,
campaign_id uuid,
event_at timestamp with time zone DEFAULT now() NOT NULL,
payload jsonb DEFAULT '{}'::jsonb NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."order_email_log" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
order_id uuid NOT NULL,
event_key text NOT NULL,
recipient_email text,
status text DEFAULT 'pending'::text NOT NULL,
provider_email_id text,
error_message text,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."ai_agent_integrations" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
provider text NOT NULL,
status text DEFAULT 'disconnected'::text NOT NULL,
access_token text,
refresh_token text,
api_domain text,
scope text,
expires_at timestamp with time zone,
connected_by uuid,
metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
last_error text,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
account_key text DEFAULT 'default'::text NOT NULL
);

CREATE TABLE public."ai_agent_threads" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
created_by uuid NOT NULL,
title text DEFAULT 'New conversation'::text NOT NULL,
status text DEFAULT 'active'::text NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."ai_agent_messages" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
thread_id uuid NOT NULL,
role text NOT NULL,
content text NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."ai_agent_tasks" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
created_by uuid NOT NULL,
thread_id uuid,
title text NOT NULL,
description text,
category text DEFAULT 'administration'::text NOT NULL,
priority text DEFAULT 'normal'::text NOT NULL,
status text DEFAULT 'open'::text NOT NULL,
due_at timestamp with time zone,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."ai_agent_approvals" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
created_by uuid NOT NULL,
thread_id uuid,
action_type text NOT NULL,
title text NOT NULL,
payload jsonb DEFAULT '{}'::jsonb NOT NULL,
status text DEFAULT 'pending'::text NOT NULL,
approved_by uuid,
approved_at timestamp with time zone,
executed_at timestamp with time zone,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."ai_agent_activity" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
actor_user_id uuid,
thread_id uuid,
event_type text NOT NULL,
summary text NOT NULL,
metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE public."product_reviews" (
id uuid DEFAULT gen_random_uuid() NOT NULL,
product_id uuid NOT NULL,
order_id uuid NOT NULL,
user_id uuid NOT NULL,
rating smallint NOT NULL,
title text,
review text NOT NULL,
reviewer_name text,
status text DEFAULT 'pending'::text NOT NULL,
admin_note text,
created_at timestamp with time zone DEFAULT now() NOT NULL,
updated_at timestamp with time zone DEFAULT now() NOT NULL,
moderated_at timestamp with time zone,
moderated_by uuid
);

ALTER TABLE public."profiles" ADD CONSTRAINT "profiles_pkey" PRIMARY KEY (id);

ALTER TABLE public."profiles" ADD CONSTRAINT "profiles_role_check" CHECK ((role = ANY (ARRAY['customer'::text, 'admin'::text])));

ALTER TABLE public."categories" ADD CONSTRAINT "categories_name_key" UNIQUE (name);

ALTER TABLE public."categories" ADD CONSTRAINT "categories_pkey" PRIMARY KEY (id);

ALTER TABLE public."categories" ADD CONSTRAINT "categories_slug_key" UNIQUE (slug);

ALTER TABLE public."products" ADD CONSTRAINT "products_compare_at_price_check" CHECK (((compare_at_price IS NULL) OR (compare_at_price >= (0)::numeric)));

ALTER TABLE public."products" ADD CONSTRAINT "products_default_size_grams_check" CHECK ((default_size_grams > 0));

ALTER TABLE public."products" ADD CONSTRAINT "products_pkey" PRIMARY KEY (id);

ALTER TABLE public."products" ADD CONSTRAINT "products_price_check" CHECK ((price >= (0)::numeric));

ALTER TABLE public."products" ADD CONSTRAINT "products_slug_key" UNIQUE (slug);

ALTER TABLE public."products" ADD CONSTRAINT "products_stock_quantity_check" CHECK ((stock_quantity >= 0));

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_pkey" PRIMARY KEY (id);

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_quantity_check" CHECK ((quantity > 0));

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_unit_price_check" CHECK ((unit_price >= (0)::numeric));

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_pkey" PRIMARY KEY (id);

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_price_check" CHECK ((price >= (0)::numeric));

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_product_id_size_grams_key" UNIQUE (product_id, size_grams);

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_reorder_threshold_check" CHECK ((reorder_threshold >= 0));

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_size_grams_check" CHECK ((size_grams > 0));

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_sku_key" UNIQUE (sku);

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_stock_quantity_check" CHECK ((stock_quantity >= 0));

ALTER TABLE public."storefront_content" ADD CONSTRAINT "storefront_content_id_check" CHECK (id);

ALTER TABLE public."storefront_content" ADD CONSTRAINT "storefront_content_pkey" PRIMARY KEY (id);

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_code_key" UNIQUE (code);

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_discount_type_check" CHECK ((discount_type = ANY (ARRAY['percentage'::text, 'fixed'::text])));

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_discount_value_check" CHECK ((discount_value > (0)::numeric));

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_max_uses_check" CHECK (((max_uses IS NULL) OR (max_uses > 0)));

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_minimum_order_check" CHECK ((minimum_order >= (0)::numeric));

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_pkey" PRIMARY KEY (id);

ALTER TABLE public."coupons" ADD CONSTRAINT "coupons_used_count_check" CHECK ((used_count >= 0));

ALTER TABLE public."newsletter_subscribers" ADD CONSTRAINT "newsletter_subscribers_pkey" PRIMARY KEY (id);

ALTER TABLE public."newsletter_subscribers" ADD CONSTRAINT "newsletter_subscribers_status_check" CHECK ((status = ANY (ARRAY['subscribed'::text, 'unsubscribed'::text])));

ALTER TABLE public."blog_posts" ADD CONSTRAINT "blog_posts_pkey" PRIMARY KEY (id);

ALTER TABLE public."blog_posts" ADD CONSTRAINT "blog_posts_slug_key" UNIQUE (slug);

ALTER TABLE public."content_pages" ADD CONSTRAINT "content_pages_menu_location_check" CHECK ((menu_location = ANY (ARRAY['main'::text, 'company'::text, 'customer_service'::text, 'footer'::text, 'none'::text])));

ALTER TABLE public."content_pages" ADD CONSTRAINT "content_pages_pkey" PRIMARY KEY (id);

ALTER TABLE public."content_pages" ADD CONSTRAINT "content_pages_slug_key" UNIQUE (slug);

ALTER TABLE public."company_pages" ADD CONSTRAINT "company_pages_page_key_check" CHECK ((page_key = ANY (ARRAY['about'::text, 'story'::text, 'careers'::text])));

ALTER TABLE public."company_pages" ADD CONSTRAINT "company_pages_page_key_key" UNIQUE (page_key);

ALTER TABLE public."company_pages" ADD CONSTRAINT "company_pages_pkey" PRIMARY KEY (id);

ALTER TABLE public."orders" ADD CONSTRAINT "orders_delivery_fee_check" CHECK ((delivery_fee >= (0)::numeric));

ALTER TABLE public."orders" ADD CONSTRAINT "orders_payment_reference_key" UNIQUE (payment_reference);

ALTER TABLE public."orders" ADD CONSTRAINT "orders_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text])));

ALTER TABLE public."orders" ADD CONSTRAINT "orders_pkey" PRIMARY KEY (id);

ALTER TABLE public."orders" ADD CONSTRAINT "orders_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'processing'::text, 'shipped'::text, 'delivered'::text, 'cancelled'::text])));

ALTER TABLE public."orders" ADD CONSTRAINT "orders_subtotal_check" CHECK ((subtotal >= (0)::numeric));

ALTER TABLE public."orders" ADD CONSTRAINT "orders_total_check" CHECK ((total >= (0)::numeric));

ALTER TABLE public."homepage_sections" ADD CONSTRAINT "homepage_sections_pkey" PRIMARY KEY (id);

ALTER TABLE public."homepage_sections" ADD CONSTRAINT "homepage_sections_section_key_key" UNIQUE (section_key);

ALTER TABLE public."newsletter_campaigns" ADD CONSTRAINT "newsletter_campaigns_pkey" PRIMARY KEY (id);

ALTER TABLE public."newsletter_campaigns" ADD CONSTRAINT "newsletter_campaigns_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'sent'::text, 'failed'::text])));

ALTER TABLE public."stock_movements" ADD CONSTRAINT "stock_movements_pkey" PRIMARY KEY (id);

ALTER TABLE public."newsletter_events" ADD CONSTRAINT "newsletter_events_event_type_check" CHECK ((event_type = ANY (ARRAY['email.sent'::text, 'email.delivered'::text, 'email.opened'::text, 'email.clicked'::text, 'email.bounced'::text, 'email.complained'::text, 'email.failed'::text, 'email.suppressed'::text, 'email.delivery_delayed'::text])));

ALTER TABLE public."newsletter_events" ADD CONSTRAINT "newsletter_events_pkey" PRIMARY KEY (id);

ALTER TABLE public."newsletter_events" ADD CONSTRAINT "newsletter_events_resend_event_id_key" UNIQUE (resend_event_id);

ALTER TABLE public."order_email_log" ADD CONSTRAINT "order_email_log_order_id_event_key_key" UNIQUE (order_id, event_key);

ALTER TABLE public."order_email_log" ADD CONSTRAINT "order_email_log_pkey" PRIMARY KEY (id);

ALTER TABLE public."order_email_log" ADD CONSTRAINT "order_email_log_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'sent'::text, 'skipped'::text, 'failed'::text])));

ALTER TABLE public."ai_agent_integrations" ADD CONSTRAINT "ai_agent_integrations_pkey" PRIMARY KEY (id);

ALTER TABLE public."ai_agent_integrations" ADD CONSTRAINT "ai_agent_integrations_status_check" CHECK ((status = ANY (ARRAY['disconnected'::text, 'active'::text, 'error'::text])));

ALTER TABLE public."ai_agent_threads" ADD CONSTRAINT "ai_agent_threads_pkey" PRIMARY KEY (id);

ALTER TABLE public."ai_agent_threads" ADD CONSTRAINT "ai_agent_threads_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text])));

ALTER TABLE public."ai_agent_messages" ADD CONSTRAINT "ai_agent_messages_pkey" PRIMARY KEY (id);

ALTER TABLE public."ai_agent_messages" ADD CONSTRAINT "ai_agent_messages_role_check" CHECK ((role = ANY (ARRAY['user'::text, 'assistant'::text, 'system'::text])));

ALTER TABLE public."ai_agent_tasks" ADD CONSTRAINT "ai_agent_tasks_pkey" PRIMARY KEY (id);

ALTER TABLE public."ai_agent_tasks" ADD CONSTRAINT "ai_agent_tasks_priority_check" CHECK ((priority = ANY (ARRAY['low'::text, 'normal'::text, 'high'::text, 'urgent'::text])));

ALTER TABLE public."ai_agent_tasks" ADD CONSTRAINT "ai_agent_tasks_status_check" CHECK ((status = ANY (ARRAY['open'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text])));

ALTER TABLE public."ai_agent_approvals" ADD CONSTRAINT "ai_agent_approvals_pkey" PRIMARY KEY (id);

ALTER TABLE public."ai_agent_approvals" ADD CONSTRAINT "ai_agent_approvals_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'executed'::text, 'failed'::text])));

ALTER TABLE public."ai_agent_activity" ADD CONSTRAINT "ai_agent_activity_pkey" PRIMARY KEY (id);

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_admin_note_check" CHECK ((char_length(admin_note) <= 500));

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_order_id_product_id_user_id_key" UNIQUE (order_id, product_id, user_id);

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_pkey" PRIMARY KEY (id);

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_rating_check" CHECK (((rating >= 1) AND (rating <= 5)));

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_review_check" CHECK (((char_length(review) >= 10) AND (char_length(review) <= 2000)));

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_reviewer_name_check" CHECK ((char_length(reviewer_name) <= 120));

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])));

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_title_check" CHECK ((char_length(title) <= 120));

ALTER TABLE public."profiles" ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public."products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;

ALTER TABLE public."order_items" ADD CONSTRAINT "order_items_variant_id_fkey" FOREIGN KEY (variant_id) REFERENCES product_variants(id);

ALTER TABLE public."product_variants" ADD CONSTRAINT "product_variants_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

ALTER TABLE public."newsletter_subscribers" ADD CONSTRAINT "newsletter_subscribers_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."orders" ADD CONSTRAINT "orders_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE RESTRICT;

ALTER TABLE public."newsletter_campaigns" ADD CONSTRAINT "newsletter_campaigns_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."stock_movements" ADD CONSTRAINT "stock_movements_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

ALTER TABLE public."stock_movements" ADD CONSTRAINT "stock_movements_variant_id_fkey" FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE;

ALTER TABLE public."newsletter_events" ADD CONSTRAINT "newsletter_events_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES newsletter_campaigns(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_integrations" ADD CONSTRAINT "ai_agent_integrations_connected_by_fkey" FOREIGN KEY (connected_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_threads" ADD CONSTRAINT "ai_agent_threads_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public."ai_agent_messages" ADD CONSTRAINT "ai_agent_messages_thread_id_fkey" FOREIGN KEY (thread_id) REFERENCES ai_agent_threads(id) ON DELETE CASCADE;

ALTER TABLE public."ai_agent_tasks" ADD CONSTRAINT "ai_agent_tasks_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public."ai_agent_tasks" ADD CONSTRAINT "ai_agent_tasks_thread_id_fkey" FOREIGN KEY (thread_id) REFERENCES ai_agent_threads(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_approvals" ADD CONSTRAINT "ai_agent_approvals_approved_by_fkey" FOREIGN KEY (approved_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_approvals" ADD CONSTRAINT "ai_agent_approvals_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public."ai_agent_approvals" ADD CONSTRAINT "ai_agent_approvals_thread_id_fkey" FOREIGN KEY (thread_id) REFERENCES ai_agent_threads(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_activity" ADD CONSTRAINT "ai_agent_activity_actor_user_id_fkey" FOREIGN KEY (actor_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."ai_agent_activity" ADD CONSTRAINT "ai_agent_activity_thread_id_fkey" FOREIGN KEY (thread_id) REFERENCES ai_agent_threads(id) ON DELETE SET NULL;

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_moderated_by_fkey" FOREIGN KEY (moderated_by) REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

ALTER TABLE public."product_reviews" ADD CONSTRAINT "product_reviews_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE OR REPLACE FUNCTION public.admin_bulk_update_variant_stock(p_updates jsonb)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_item jsonb;
  v_id uuid;
  v_stock integer;
  v_count integer := 0;
  v_product_id uuid;
  v_size_grams integer;
  v_default_size integer;
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;

  if jsonb_typeof(coalesce(p_updates,'[]'::jsonb)) <> 'array' then
    raise exception 'Updates must be an array';
  end if;

  for v_item in select value from jsonb_array_elements(coalesce(p_updates,'[]'::jsonb)) loop
    v_id := nullif(v_item->>'variant_id','')::uuid;
    v_stock := (v_item->>'stock_quantity')::integer;
    if v_id is null or v_stock is null or v_stock < 0 then
      raise exception 'Invalid stock update';
    end if;

    update public.product_variants
       set stock_quantity = v_stock,
           updated_at = now()
     where id = v_id
     returning product_id, size_grams into v_product_id, v_size_grams;

    if found then
      select default_size_grams into v_default_size from public.products where id = v_product_id;
      if v_default_size = v_size_grams then
        update public.products
           set stock_quantity = v_stock,
               updated_at = now()
         where id = v_product_id;
      end if;
      v_count := v_count + 1;
    end if;
  end loop;

  return v_count;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_create_product_with_variants(p_product jsonb, p_variants jsonb DEFAULT '[]'::jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_id uuid; v_slug text; v_base text; v_n int:=1; v jsonb; v_default numeric; v_default_stock int;
begin
 if not public.is_admin() then raise exception 'Administrator access required'; end if;
 v_base:=regexp_replace(lower(trim(coalesce(p_product->>'name',''))),'[^a-z0-9]+','-','g'); v_base:=trim(both '-' from v_base); if v_base='' then raise exception 'Product name required'; end if;
 v_slug:=v_base; while exists(select 1 from public.products where slug=v_slug) loop v_n:=v_n+1; v_slug:=v_base||'-'||v_n; end loop;
 insert into public.products(name,slug,description,price,stock_quantity,default_size_grams,category_id,featured,is_active)
 values(trim(p_product->>'name'),v_slug,nullif(trim(coalesce(p_product->>'description','')),''),coalesce((p_product->>'price')::numeric,0),coalesce((p_product->>'stock_quantity')::int,0),coalesce((p_product->>'default_size_grams')::int,500),nullif(p_product->>'category_id','')::uuid,coalesce((p_product->>'featured')::boolean,false),coalesce((p_product->>'is_active')::boolean,true)) returning id into v_id;
 for v in select value from jsonb_array_elements(coalesce(p_variants,'[]'::jsonb)) loop
   if trim(coalesce(v->>'size_label',''))<>'' and coalesce((v->>'size_grams')::int,0)>0 then
    insert into public.product_variants(product_id,size_label,size_grams,price,stock_quantity,is_active)
    values(v_id,trim(v->>'size_label'),(v->>'size_grams')::int,coalesce((v->>'price')::numeric,0),coalesce((v->>'stock_quantity')::int,0),coalesce((v->>'is_active')::boolean,true));
   end if;
 end loop;
 select price,stock_quantity into v_default,v_default_stock from public.product_variants where product_id=v_id and is_active and size_grams=coalesce((p_product->>'default_size_grams')::int,500) order by created_at limit 1;
 if found then update public.products set price=v_default,stock_quantity=v_default_stock where id=v_id; end if;
 return v_id;
end;$function$
;

CREATE OR REPLACE FUNCTION public.admin_manage_content(p_type text, p_id uuid, p_action text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then raise exception 'Administrator access required'; end if;
  if p_action not in ('publish','unpublish','delete') then raise exception 'Invalid action'; end if;
  if p_type = 'blog' then
    if p_action='delete' then delete from public.blog_posts where id=p_id;
    elsif p_action='publish' then update public.blog_posts set is_published=true,published_at=coalesce(published_at,now()),updated_at=now() where id=p_id;
    else update public.blog_posts set is_published=false,updated_at=now() where id=p_id; end if;
  elsif p_type = 'home' then
    if p_action='delete' then delete from public.homepage_sections where id=p_id;
    elsif p_action='publish' then update public.homepage_sections set is_published=true,updated_at=now() where id=p_id;
    else update public.homepage_sections set is_published=false,updated_at=now() where id=p_id; end if;
  elsif p_type = 'custom' then
    if p_action='delete' then delete from public.content_pages where id=p_id;
    elsif p_action='publish' then update public.content_pages set is_published=true,updated_at=now() where id=p_id;
    else update public.content_pages set is_published=false,updated_at=now() where id=p_id; end if;
  elsif p_type = 'page' then
    if p_action='delete' then delete from public.company_pages where id=p_id;
    elsif p_action='publish' then update public.company_pages set is_published=true,updated_at=now() where id=p_id;
    else update public.company_pages set is_published=false,updated_at=now() where id=p_id; end if;
  else raise exception 'Invalid content type'; end if;
  return true;
end;$function$
;

CREATE OR REPLACE FUNCTION public.admin_moderate_product_review(p_review_id uuid, p_status text, p_admin_note text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if auth.uid() is null or not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Admin access required.'; end if;
  if p_status not in ('approved','rejected') then raise exception 'Invalid moderation status.'; end if;
  update public.product_reviews set status=p_status,admin_note=nullif(trim(coalesce(p_admin_note,'')),''),moderated_at=now(),moderated_by=auth.uid(),updated_at=now() where id=p_review_id;
  return found;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_content(p_type text, p_id uuid, p_payload jsonb)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
 if not public.is_admin() then raise exception 'Administrator access required'; end if;
 if p_type='home' then
  update public.homepage_sections set
   section_name=coalesce(p_payload->>'section_name',section_name),
   eyebrow=coalesce(p_payload->>'eyebrow',eyebrow),
   title=coalesce(p_payload->>'title',title),
   content=coalesce(p_payload->>'content',content),
   button_label=coalesce(p_payload->>'button_label',button_label),
   button_url=coalesce(p_payload->>'button_url',button_url),
   updated_at=now() where id=p_id;
 elsif p_type='blog' then
  update public.blog_posts set
   title=coalesce(p_payload->>'title',title),
   category=coalesce(p_payload->>'category',category),
   excerpt=coalesce(p_payload->>'excerpt',excerpt),
   content=coalesce(p_payload->>'content',content),
   featured_image_url=coalesce(p_payload->>'featured_image_url',featured_image_url),
   updated_at=now() where id=p_id;
 elsif p_type='custom' then
  update public.content_pages set
   title=coalesce(p_payload->>'title',title),
   excerpt=coalesce(p_payload->>'excerpt',excerpt),
   content=coalesce(p_payload->>'content',content),
   menu_location=coalesce(p_payload->>'menu_location',menu_location),
   featured_image_url=coalesce(p_payload->>'featured_image_url',featured_image_url),
   updated_at=now() where id=p_id;
 elsif p_type='page' then
  update public.company_pages set
   title=coalesce(p_payload->>'title',title),
   eyebrow=coalesce(p_payload->>'eyebrow',eyebrow),
   intro=coalesce(p_payload->>'intro',intro),
   content=coalesce(p_payload->>'content',content),
   secondary_title=coalesce(p_payload->>'secondary_title',secondary_title),
   secondary_content=coalesce(p_payload->>'secondary_content',secondary_content),
   updated_at=now() where id=p_id;
 else raise exception 'Invalid content type'; end if;
 return true;
end;$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_order_status(p_order_id uuid, p_status text, p_payment_status text)
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
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  if p_status not in ('pending','processing','shipped','delivered','cancelled') then raise exception 'Invalid order status'; end if;
  if p_payment_status not in ('pending','paid','failed','refunded') then raise exception 'Invalid payment status'; end if;
  select * into o from public.orders where id=p_order_id for update;
  if not found then raise exception 'Order not found'; end if;

  if p_status='cancelled' and o.status<>'cancelled' and o.inventory_allocated_at is not null and o.inventory_released_at is null then
    for x in select variant_id,product_id,quantity from public.order_items where order_id=o.id loop
      if x.variant_id is not null then update public.product_variants set stock_quantity=stock_quantity+x.quantity,updated_at=now() where id=x.variant_id;
      else update public.products set stock_quantity=stock_quantity+x.quantity,updated_at=now() where id=x.product_id; end if;
    end loop;
    update public.orders set inventory_released_at=now() where id=o.id;
  elsif p_status<>'cancelled' and o.status='cancelled' and o.inventory_allocated_at is not null and o.inventory_released_at is not null then
    for x in select variant_id,product_id,quantity,product_name from public.order_items where order_id=o.id loop
      if x.variant_id is not null then
        select stock_quantity into v_stock from public.product_variants where id=x.variant_id for update;
        if v_stock<x.quantity then raise exception 'Insufficient stock to reopen order for %',coalesce(x.product_name,'product'); end if;
      else
        select stock_quantity into v_stock from public.products where id=x.product_id for update;
        if v_stock<x.quantity then raise exception 'Insufficient stock to reopen order for %',coalesce(x.product_name,'product'); end if;
      end if;
    end loop;
    for x in select variant_id,product_id,quantity from public.order_items where order_id=o.id loop
      if x.variant_id is not null then update public.product_variants set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.variant_id;
      else update public.products set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.product_id; end if;
    end loop;
    update public.orders set inventory_released_at=null where id=o.id;
  end if;

  update public.orders set status=p_status,payment_status=p_payment_status,updated_at=now() where id=o.id;
  return o.id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_reorder_threshold(p_variant_id uuid, p_threshold integer)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Administrator access required';
  end if;
  if p_threshold is null or p_threshold < 0 then
    raise exception 'Reorder threshold must be zero or greater';
  end if;
  update public.product_variants
     set reorder_threshold = p_threshold,
         updated_at = now()
   where id = p_variant_id
   returning id into p_variant_id;
  if p_variant_id is null then
    raise exception 'Variant not found';
  end if;
  return p_variant_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_variant_stock(p_variant_id uuid, p_stock integer)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_product_id uuid;
  v_size_grams integer;
  v_default_size integer;
begin
  if not public.is_admin() then
    raise exception 'Administrator access required';
  end if;
  if p_stock < 0 then
    raise exception 'Stock cannot be negative';
  end if;

  update public.product_variants
     set stock_quantity = p_stock,
         updated_at = now()
   where id = p_variant_id
   returning product_id, size_grams into v_product_id, v_size_grams;

  if v_product_id is null then
    raise exception 'Variant not found';
  end if;

  select default_size_grams into v_default_size
  from public.products
  where id = v_product_id;

  if v_default_size = v_size_grams then
    update public.products
       set stock_quantity = p_stock,
           updated_at = now()
     where id = v_product_id;
  end if;

  return p_variant_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_upsert_product_variant(p_product_id uuid, p_variant_id uuid, p_size_label text, p_size_grams integer, p_price numeric, p_stock integer, p_is_active boolean DEFAULT true)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_id uuid; v_default int;
begin
 if not public.is_admin() then raise exception 'Administrator access required'; end if;
 if trim(coalesce(p_size_label,''))='' or p_size_grams<=0 or p_price<0 or p_stock<0 then raise exception 'Invalid variant values'; end if;
 if p_variant_id is null then insert into public.product_variants(product_id,size_label,size_grams,price,stock_quantity,is_active) values(p_product_id,trim(p_size_label),p_size_grams,p_price,p_stock,p_is_active) returning id into v_id;
 else update public.product_variants set size_label=trim(p_size_label),size_grams=p_size_grams,price=p_price,stock_quantity=p_stock,is_active=p_is_active,updated_at=now() where id=p_variant_id and product_id=p_product_id returning id into v_id; if v_id is null then raise exception 'Variant not found'; end if; end if;
 select default_size_grams into v_default from public.products where id=p_product_id;
 if p_is_active and p_size_grams=v_default then update public.products set price=p_price,stock_quantity=p_stock,updated_at=now() where id=p_product_id; end if;
 return v_id;
end;$function$
;

CREATE OR REPLACE FUNCTION public.allocate_order_inventory(p_order_id uuid)
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
  if o.inventory_allocated_at is not null and o.inventory_released_at is null then return o.id; end if;
  if o.status='cancelled' then raise exception 'Cannot allocate inventory to a cancelled order'; end if;

  for x in select variant_id,product_id,quantity,product_name from public.order_items where order_id=o.id loop
    if x.variant_id is not null then
      select stock_quantity into v_stock from public.product_variants where id=x.variant_id for update;
      if not found then raise exception 'Variant not found for %',coalesce(x.product_name,'product'); end if;
      if v_stock<x.quantity then raise exception 'Insufficient stock for %',coalesce(x.product_name,'product'); end if;
    else
      select stock_quantity into v_stock from public.products where id=x.product_id for update;
      if not found then raise exception 'Product not found for %',coalesce(x.product_name,'product'); end if;
      if v_stock<x.quantity then raise exception 'Insufficient stock for %',coalesce(x.product_name,'product'); end if;
    end if;
  end loop;

  for x in select variant_id,product_id,quantity from public.order_items where order_id=o.id loop
    if x.variant_id is not null then
      update public.product_variants set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.variant_id;
    else
      update public.products set stock_quantity=stock_quantity-x.quantity,updated_at=now() where id=x.product_id;
    end if;
  end loop;

  update public.orders set inventory_allocated_at=now(),inventory_released_at=null,updated_at=now() where id=o.id;
  return o.id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.apply_coupon_to_order(p_order_id uuid, p_code text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ declare o public.orders; c public.coupons; d numeric; begin select * into o from public.orders where id=p_order_id and payment_status='pending' for update; if not found then raise exception 'Pending order not found'; end if; select * into c from public.coupons where upper(code)=upper(trim(p_code)) and is_active=true for update; if not found then raise exception 'Coupon not found or inactive'; end if; if c.starts_at is not null and now()<c.starts_at then raise exception 'Coupon is not active yet'; end if; if c.expires_at is not null and now()>c.expires_at then raise exception 'Coupon has expired'; end if; if c.max_uses is not null and c.used_count>=c.max_uses then raise exception 'Coupon usage limit reached'; end if; if o.subtotal<c.minimum_order then raise exception 'Minimum order value not reached'; end if; d:=case when c.discount_type='percentage' then least(o.subtotal,o.subtotal*c.discount_value/100) else least(o.subtotal,c.discount_value) end; update public.orders set coupon_code=c.code,discount_amount=round(d,2),total=greatest(0,subtotal+delivery_fee-round(d,2)),updated_at=now() where id=o.id; return jsonb_build_object('code',c.code,'discount',round(d,2),'total',greatest(0,o.subtotal+o.delivery_fee-round(d,2))); end $function$
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
  if o.user_id is distinct from auth.uid() then raise exception 'Order access denied'; end if;
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

CREATE OR REPLACE FUNCTION public.create_admin_newsletter_campaign(p_subject text, p_preview_text text, p_body_html text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_id uuid;
begin
 if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Access denied'; end if;
 insert into public.newsletter_campaigns(subject,preview_text,body_html,created_by) values(trim(p_subject),nullif(trim(p_preview_text),''),p_body_html,auth.uid()) returning id into v_id;
 return v_id;
end;$function$
;

CREATE OR REPLACE FUNCTION public.create_checkout_order(p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text DEFAULT 'paystack'::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_order_id uuid:=gen_random_uuid(); v_subtotal numeric:=0; v_fee numeric:=0; v_item jsonb; v_product record; v_variant record; v_qty int; v_variant_id uuid; v_existing uuid; begin
 if coalesce(trim(p_email),'')='' then raise exception 'Email is required'; end if;
 if p_payment_method not in ('paystack','pay_after_delivery') then raise exception 'Invalid payment method'; end if;
 if jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Order must contain at least one item'; end if;
 v_fee:=case lower(trim(coalesce(p_delivery_zone,''))) when 'ibadan' then 2000 when 'lagos' then 5000 when 'other' then 8000 else null end; if v_fee is null then raise exception 'Select a valid delivery location'; end if;
 if p_payment_method='paystack' and coalesce(trim(p_payment_reference),'')='' then raise exception 'Payment reference is required'; end if;
 if coalesce(trim(p_payment_reference),'')<>'' then select id into v_existing from public.orders where payment_reference=p_payment_reference limit 1; if v_existing is not null then return v_existing; end if; end if;
 for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.stock_quantity,pv.is_active,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id for update of pv; if not found or not v_variant.is_active or v_variant.stock_quantity<v_qty then raise exception 'Selected product size is unavailable'; end if; v_subtotal:=v_subtotal+v_variant.price*v_qty; else select id,name,price,stock_quantity,is_active into v_product from public.products where id=(v_item->>'id')::uuid for update; if not found or not v_product.is_active or v_product.stock_quantity<v_qty then raise exception 'Product is unavailable'; end if; v_subtotal:=v_subtotal+v_product.price*v_qty; end if; end loop;
 insert into public.orders(id,user_id,customer_name,email,status,payment_status,payment_reference,subtotal,delivery_fee,total,delivery_address,delivery_zone,phone,payment_method) values(v_order_id,auth.uid(),nullif(trim(p_customer_name),''),trim(p_email),'pending','pending',nullif(trim(p_payment_reference),''),v_subtotal,v_fee,v_subtotal+v_fee,nullif(trim(p_delivery_address),''),lower(trim(p_delivery_zone)),nullif(trim(p_phone),''),p_payment_method);
 for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.size_grams,pv.size_label,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id; insert into public.order_items(order_id,product_id,variant_id,product_name,unit_price,quantity,size_grams,size_label,line_total) values(v_order_id,v_variant.product_id,v_variant.id,v_variant.name,v_variant.price,v_qty,v_variant.size_grams,v_variant.size_label,v_variant.price*v_qty); else select id,name,price into v_product from public.products where id=(v_item->>'id')::uuid; insert into public.order_items(order_id,product_id,product_name,unit_price,quantity,line_total) values(v_order_id,v_product.id,v_product.name,v_product.price,v_qty,v_product.price*v_qty); end if; end loop;
 return v_order_id; end; $function$
;

CREATE OR REPLACE FUNCTION public.create_checkout_order_v2(p_user_id uuid, p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text DEFAULT 'paystack'::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ declare v_order_id uuid:=gen_random_uuid(); v_subtotal numeric:=0; v_fee numeric:=0; v_item jsonb; v_product record; v_variant record; v_qty int; v_variant_id uuid; v_existing uuid; begin if auth.uid() is null or p_user_id is distinct from auth.uid() then raise exception 'Order access denied'; end if; if coalesce(trim(p_email),'')='' then raise exception 'Email is required'; end if; if p_payment_method not in ('paystack','pay_after_delivery') then raise exception 'Invalid payment method'; end if; if jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Order must contain at least one item'; end if; v_fee:=case lower(trim(coalesce(p_delivery_zone,''))) when 'ibadan' then 2000 when 'lagos' then 5000 when 'other' then 8000 else null end; if v_fee is null then raise exception 'Select a valid delivery location'; end if; if p_payment_method='paystack' and coalesce(trim(p_payment_reference),'')='' then raise exception 'Payment reference is required'; end if; if coalesce(trim(p_payment_reference),'')<>'' then select id into v_existing from public.orders where payment_reference=p_payment_reference and user_id=auth.uid() limit 1; if v_existing is not null then return v_existing; end if; end if; for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.stock_quantity,pv.is_active,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id and p.is_active=true and p.id=(v_item->>'id')::uuid and pv.price>0 for update of pv; if not found or not v_variant.is_active or v_variant.stock_quantity<v_qty then raise exception 'Selected product size is unavailable'; end if; v_subtotal:=v_subtotal+v_variant.price*v_qty; else select id,name,price,stock_quantity,is_active into v_product from public.products where id=(v_item->>'id')::uuid for update; if not found or not v_product.is_active or v_product.stock_quantity<v_qty then raise exception 'Product is unavailable'; end if; v_subtotal:=v_subtotal+v_product.price*v_qty; end if; end loop; insert into public.orders(id,user_id,customer_name,email,status,payment_status,payment_reference,subtotal,delivery_fee,total,delivery_address,delivery_zone,phone,payment_method) values(v_order_id,p_user_id,nullif(trim(p_customer_name),''),trim(p_email),'pending','pending',nullif(trim(p_payment_reference),''),v_subtotal,v_fee,v_subtotal+v_fee,nullif(trim(p_delivery_address),''),lower(trim(p_delivery_zone)),nullif(trim(p_phone),''),p_payment_method); for v_item in select * from jsonb_array_elements(p_items) loop v_qty:=greatest(1,least(coalesce((v_item->>'quantity')::int,1),100)); v_variant_id:=nullif(v_item->>'variant_id','')::uuid; if v_variant_id is not null then select pv.id,pv.product_id,pv.price,pv.size_grams,pv.size_label,p.name into v_variant from public.product_variants pv join public.products p on p.id=pv.product_id where pv.id=v_variant_id; insert into public.order_items(order_id,product_id,variant_id,product_name,unit_price,quantity,size_grams,size_label) values(v_order_id,v_variant.product_id,v_variant.id,v_variant.name,v_variant.price,v_qty,v_variant.size_grams,v_variant.size_label); else select id,name,price into v_product from public.products where id=(v_item->>'id')::uuid; insert into public.order_items(order_id,product_id,product_name,unit_price,quantity) values(v_order_id,v_product.id,v_product.name,v_product.price,v_qty); end if; end loop; return v_order_id; end; $function$
;

CREATE OR REPLACE FUNCTION public.create_pending_order(p_email text, p_phone text, p_delivery_address text, p_items jsonb, p_payment_reference text, p_customer_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_order_id uuid := gen_random_uuid();
  v_subtotal numeric := 0;
  v_item jsonb;
  v_product record;
  v_variant record;
  v_qty integer;
  v_variant_id uuid;
  v_existing uuid;
begin
  if coalesce(trim(p_email), '') = '' or coalesce(trim(p_payment_reference), '') = '' then
    raise exception 'Email and payment reference are required';
  end if;
  if jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'Order must contain at least one item';
  end if;
  select id into v_existing from public.orders where payment_reference = p_payment_reference limit 1;
  if v_existing is not null then return v_existing; end if;

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := greatest(1, least(coalesce((v_item->>'quantity')::integer, 1), 100));
    v_variant_id := nullif(v_item->>'variant_id','')::uuid;
    if v_variant_id is not null then
      select pv.id,pv.product_id,pv.price,pv.stock_quantity,pv.is_active,p.name
        into v_variant
      from public.product_variants pv join public.products p on p.id=pv.product_id
      where pv.id=v_variant_id for update of pv;
      if not found or not v_variant.is_active then raise exception 'Product size is unavailable'; end if;
      if not v_variant.stock_quantity >= v_qty then raise exception 'Insufficient stock for %', v_variant.name; end if;
      v_subtotal := v_subtotal + v_variant.price * v_qty;
    else
      select id,name,price,stock_quantity,is_active into v_product from public.products where id=(v_item->>'id')::uuid for update;
      if not found or not v_product.is_active then raise exception 'Product is unavailable'; end if;
      if v_product.stock_quantity < v_qty then raise exception 'Insufficient stock for %',v_product.name; end if;
      v_subtotal := v_subtotal + v_product.price * v_qty;
    end if;
  end loop;

  insert into public.orders(id,user_id,customer_name,email,status,payment_status,payment_reference,subtotal,delivery_fee,total,delivery_address,phone)
  values(v_order_id,auth.uid(),nullif(trim(p_customer_name),''),nullif(trim(p_email),''),'pending','pending',p_payment_reference,v_subtotal,0,v_subtotal,nullif(trim(p_delivery_address),''),nullif(trim(p_phone),''));

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := greatest(1,least(coalesce((v_item->>'quantity')::integer,1),100));
    v_variant_id := nullif(v_item->>'variant_id','')::uuid;
    if v_variant_id is not null then
      select pv.id,pv.product_id,pv.price,pv.size_grams,pv.size_label,p.name
        into v_variant
      from public.product_variants pv join public.products p on p.id=pv.product_id
      where pv.id=v_variant_id;
      insert into public.order_items(order_id,product_id,variant_id,product_name,unit_price,quantity,size_grams,size_label,line_total)
      values(v_order_id,v_variant.product_id,v_variant.id,v_variant.name,v_variant.price,v_qty,v_variant.size_grams,v_variant.size_label,v_variant.price*v_qty);
    else
      select id,name,price into v_product from public.products where id=(v_item->>'id')::uuid;
      insert into public.order_items(order_id,product_id,product_name,unit_price,quantity,line_total)
      values(v_order_id,v_product.id,v_product.name,v_product.price,v_qty,v_product.price*v_qty);
    end if;
  end loop;
  return v_order_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_management_reports(p_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_to timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_from timestamptz := coalesce(p_from, date_trunc('month', now()));
  v_to timestamptz := coalesce(p_to, now());
  v_result jsonb;
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  if v_to < v_from then raise exception 'Invalid report period'; end if;

  with paid as (
    select * from public.orders
    where payment_status='paid' and status <> 'cancelled' and created_at >= v_from and created_at <= v_to
  ), all_period as (
    select * from public.orders where created_at >= v_from and created_at <= v_to
  ), product_sales as (
    select oi.product_name, sum(oi.quantity)::int units_sold, sum(oi.line_total)::numeric revenue
    from public.order_items oi join paid o on o.id=oi.order_id
    group by oi.product_name order by revenue desc
  ), customer_sales as (
    select coalesce(nullif(o.customer_name,''), nullif(o.email,''), 'Customer') customer_name,
           o.email, count(*)::int orders, sum(o.total)::numeric spend
    from paid o group by coalesce(nullif(o.customer_name,''), nullif(o.email,''), 'Customer'), o.email order by spend desc
  ), payment_mix as (
    select coalesce(payment_method,'unknown') method,count(*)::int orders,sum(total)::numeric revenue
    from paid group by coalesce(payment_method,'unknown') order by revenue desc
  ), status_mix as (
    select status,count(*)::int orders from all_period group by status order by orders desc
  ), inventory as (
    select count(*) filter(where pv.is_active)::int active_variants,
      coalesce(sum(pv.stock_quantity) filter(where pv.is_active),0)::int stock_units,
      coalesce(sum(pv.stock_quantity * coalesce(pv.price,p.price,0)) filter(where pv.is_active),0)::numeric retail_stock_value,
      count(*) filter(where pv.is_active and pv.stock_quantity=0)::int out_of_stock,
      count(*) filter(where pv.is_active and pv.stock_quantity>0 and pv.stock_quantity<=pv.reorder_threshold)::int low_stock
    from public.product_variants pv join public.products p on p.id=pv.product_id
  )
  select jsonb_build_object(
    'period',jsonb_build_object('from',v_from,'to',v_to),
    'summary',jsonb_build_object(
      'orders',(select count(*) from all_period),
      'paid_orders',(select count(*) from paid),
      'gross_product_sales',coalesce((select sum(subtotal) from paid),0),
      'discounts',coalesce((select sum(discount_amount) from paid),0),
      'delivery_fees',coalesce((select sum(delivery_fee) from paid),0),
      'net_revenue',coalesce((select sum(total) from paid),0),
      'average_order_value',coalesce((select avg(total) from paid),0),
      'unique_customers',(select count(distinct coalesce(user_id::text,email)) from paid)
    ),
    'products',coalesce((select jsonb_agg(to_jsonb(product_sales)) from product_sales),'[]'::jsonb),
    'customers',coalesce((select jsonb_agg(to_jsonb(customer_sales)) from (select * from customer_sales limit 10) customer_sales),'[]'::jsonb),
    'payment_methods',coalesce((select jsonb_agg(to_jsonb(payment_mix)) from payment_mix),'[]'::jsonb),
    'order_statuses',coalesce((select jsonb_agg(to_jsonb(status_mix)) from status_mix),'[]'::jsonb),
    'inventory',(select to_jsonb(inventory) from inventory)
  ) into v_result;
  return v_result;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_newsletter_event_summary()
 RETURNS TABLE(event_type text, event_count bigint)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin') then
    raise exception 'Admin access required';
  end if;
  return query
  select ne.event_type, count(*)::bigint
  from public.newsletter_events ne
  group by ne.event_type;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_newsletter_events(p_limit integer DEFAULT 50)
 RETURNS TABLE(id uuid, resend_email_id text, event_type text, recipient_email text, subject text, event_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin') then
    raise exception 'Admin access required';
  end if;
  return query
  select ne.id, ne.resend_email_id, ne.event_type, ne.recipient_email, ne.subject, ne.event_at
  from public.newsletter_events ne
  order by ne.event_at desc
  limit greatest(1, least(coalesce(p_limit,50),200));
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_sales_analytics()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_is_admin boolean;
  v_result jsonb;
begin
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  ) into v_is_admin;

  if not v_is_admin then
    raise exception 'Admin access required';
  end if;

  with paid as (
    select * from public.orders
    where payment_status = 'paid' and status <> 'cancelled'
  ),
  summary as (
    select
      count(*)::int as paid_orders,
      coalesce(sum(total),0)::numeric as revenue,
      coalesce(avg(total),0)::numeric as average_order_value,
      count(*) filter (where created_at >= now() - interval '30 days')::int as paid_orders_30d,
      coalesce(sum(total) filter (where created_at >= now() - interval '30 days'),0)::numeric as revenue_30d
    from paid
  ),
  top_products as (
    select oi.product_name,
           sum(oi.quantity)::int as units_sold,
           coalesce(sum(oi.line_total),0)::numeric as sales
    from paid p
    join public.order_items oi on oi.order_id = p.id
    group by oi.product_name
    order by units_sold desc, sales desc
    limit 5
  ),
  payment_methods as (
    select coalesce(nullif(payment_method,''),'paystack') as method,
           count(*)::int as orders,
           coalesce(sum(total),0)::numeric as revenue
    from paid
    group by 1
    order by orders desc
  ),
  order_statuses as (
    select status, count(*)::int as orders
    from public.orders
    group by status
    order by orders desc
  )
  select jsonb_build_object(
    'summary', (select to_jsonb(summary) from summary),
    'top_products', coalesce((select jsonb_agg(to_jsonb(top_products)) from top_products),'[]'::jsonb),
    'payment_methods', coalesce((select jsonb_agg(to_jsonb(payment_methods)) from payment_methods),'[]'::jsonb),
    'order_statuses', coalesce((select jsonb_agg(to_jsonb(order_statuses)) from order_statuses),'[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_admin_status()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select exists(select 1 from public.profiles where id=auth.uid() and role='admin'); $function$
;

CREATE OR REPLACE FUNCTION public.get_my_checkout_order(p_order_id uuid)
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
 select case when o.id is null then null else jsonb_build_object(
  'id',o.id,'subtotal',o.subtotal,'delivery_fee',o.delivery_fee,'discount_amount',o.discount_amount,
  'total',o.total,'status',o.status,'payment_status',o.payment_status,'payment_method',o.payment_method
 ) end
 from public.orders o
 where o.id=p_order_id and o.user_id=auth.uid();
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_newsletter_preference()
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
declare
  v_uid uuid := auth.uid();
  v_email text;
begin
  if v_uid is null then
    raise exception 'Authentication required';
  end if;

  select email into v_email from auth.users where id = v_uid;
  if v_email is null then return false; end if;

  return exists(
    select 1
    from public.newsletter_subscribers n
    where n.status = 'subscribed'
      and (n.user_id = v_uid or lower(n.email) = lower(v_email))
  );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_orders()
 RETURNS TABLE(id uuid, status text, payment_status text, total numeric, created_at timestamp with time zone, updated_at timestamp with time zone, delivery_address text, payment_reference text, delivery_zone text, payment_method text, delivery_fee numeric, subtotal numeric, discount_amount numeric, items jsonb)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select
    o.id,
    o.status,
    o.payment_status,
    o.total,
    o.created_at,
    o.updated_at,
    o.delivery_address,
    o.payment_reference,
    o.delivery_zone,
    o.payment_method,
    o.delivery_fee,
    o.subtotal,
    o.discount_amount,
    coalesce((
      select jsonb_agg(jsonb_build_object(
        'product_id', oi.product_id,
        'variant_id', oi.variant_id,
        'product_name', oi.product_name,
        'unit_price', oi.unit_price,
        'quantity', oi.quantity,
        'line_total', oi.line_total,
        'size_grams', oi.size_grams,
        'size_label', oi.size_label
      ) order by oi.id)
      from public.order_items oi
      where oi.order_id = o.id
    ), '[]'::jsonb) as items
  from public.orders o
  where o.user_id = auth.uid()
  order by o.created_at desc;
$function$
;

CREATE OR REPLACE FUNCTION public.get_public_product_detail(p_slug text)
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select case when p.id is null then null else jsonb_build_object(
    'product', jsonb_build_object(
      'id',p.id,'name',p.name,'slug',p.slug,'description',p.description,'price',p.price,
      'image_url',p.image_url,'stock_quantity',p.stock_quantity,'featured',p.featured
    ),
    'variants', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id',v.id,'size_grams',v.size_grams,'size_label',v.size_label,
        'price',v.price,'stock_quantity',v.stock_quantity
      ) order by v.size_grams)
      from public.product_variants v
      where v.product_id=p.id and v.is_active=true
    ), '[]'::jsonb)
  ) end
  from public.products p
  where p.slug=p_slug and p.is_active=true
  limit 1;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  insert into public.profiles (id, full_name, phone, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.raw_user_meta_data ->> 'phone',
    case when not exists (select 1 from public.profiles) then 'admin' else 'customer' end
  )
  on conflict (id) do nothing;
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'); $function$
;

CREATE OR REPLACE FUNCTION public.list_admin_blog_posts()
 RETURNS SETOF blog_posts
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select * from public.blog_posts where public.is_admin() order by created_at desc; $function$
;

CREATE OR REPLACE FUNCTION public.list_admin_catalogue_categories()
 RETURNS SETOF categories
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select c.* from public.categories c
  where public.is_admin()
  order by c.name;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_catalogue_products()
 RETURNS SETOF products
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select p.* from public.products p
  where public.is_admin()
  order by p.name;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_catalogue_variants()
 RETURNS SETOF product_variants
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select v.* from public.product_variants v
  where public.is_admin()
  order by v.size_grams;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_company_pages()
 RETURNS SETOF company_pages
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select * from public.company_pages where public.is_admin() order by page_key; $function$
;

CREATE OR REPLACE FUNCTION public.list_admin_content_pages()
 RETURNS SETOF content_pages
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select * from public.content_pages where public.is_admin() order by created_at desc; $function$
;

CREATE OR REPLACE FUNCTION public.list_admin_customer_crm()
 RETURNS TABLE(user_id uuid, full_name text, email text, phone text, role text, joined_at timestamp with time zone, total_orders bigint, paid_orders bigint, delivered_orders bigint, lifetime_spend numeric, last_order_at timestamp with time zone, last_order_status text, last_payment_status text, last_delivery_address text, last_delivery_zone text, newsletter_status text, customer_type text, recent_orders jsonb)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
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
    coalesce(nullif(p.full_name,''), nullif(latest.customer_name,''), split_part(u.email,'@',1)) as full_name,
    u.email::text as email,
    coalesce(nullif(p.phone,''), nullif(latest.phone,'')) as phone,
    p.role,
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
  from public.profiles p
  join auth.users u on u.id = p.id
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
    where n.user_id = p.id or lower(n.email) = lower(u.email)
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
  where p.role <> 'admin'
  order by coalesce(os.last_order_at,p.created_at) desc;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_customer_profiles()
 RETURNS TABLE(id uuid, full_name text, phone text, role text, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;
  return query
  select p.id,p.full_name,p.phone,p.role,p.created_at
  from public.profiles p
  order by p.created_at desc
  limit 100;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_homepage_sections()
 RETURNS SETOF homepage_sections
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ select * from public.homepage_sections where public.is_admin() order by display_order; $function$
;

CREATE OR REPLACE FUNCTION public.list_admin_manageable_users()
 RETURNS TABLE(id uuid, email text, full_name text, phone text, role text, created_at timestamp with time zone)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
  select p.id, u.email::text, p.full_name, p.phone, coalesce(p.role,'customer')::text, p.created_at
  from public.profiles p
  join auth.users u on u.id = p.id
  where public.is_admin()
  order by p.created_at desc;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_newsletter_campaigns()
 RETURNS TABLE(id uuid, subject text, preview_text text, status text, sent_count integer, sent_at timestamp with time zone, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
 if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Access denied'; end if;
 return query select c.id,c.subject,c.preview_text,c.status,c.sent_count,c.sent_at,c.created_at from public.newsletter_campaigns c order by c.created_at desc;
end;$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_newsletter_subscribers()
 RETURNS TABLE(id uuid, email text, full_name text, status text, source text, consent_at timestamp with time zone, unsubscribed_at timestamp with time zone, unsubscribe_token uuid)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
 if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Access denied'; end if;
 return query select n.id,n.email,n.full_name,n.status,n.source,n.consent_at,n.unsubscribed_at,n.unsubscribe_token from public.newsletter_subscribers n order by n.created_at desc;
end;$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_order_email_history()
 RETURNS TABLE(order_id uuid, event_key text, recipient_email text, status text, provider_email_id text, error_message text, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;

  return query
  select l.order_id, l.event_key, l.recipient_email, l.status,
         l.provider_email_id, l.error_message, l.created_at, l.updated_at
  from public.order_email_log l
  order by l.updated_at desc;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_orders()
 RETURNS TABLE(id uuid, customer_name text, email text, status text, payment_status text, payment_reference text, subtotal numeric, discount_amount numeric, delivery_fee numeric, total numeric, delivery_zone text, payment_method text, phone text, delivery_address text, created_at timestamp with time zone, items jsonb)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;

  return query
  select
    o.id,
    o.customer_name,
    o.email,
    o.status,
    o.payment_status,
    o.payment_reference,
    o.subtotal,
    o.discount_amount,
    o.delivery_fee,
    o.total,
    o.delivery_zone,
    o.payment_method,
    o.phone,
    o.delivery_address,
    o.created_at,
    coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'product_name', oi.product_name,
            'size_label', oi.size_label,
            'size_grams', oi.size_grams,
            'quantity', oi.quantity,
            'unit_price', oi.unit_price,
            'line_total', oi.line_total,
            'product_id', oi.product_id,
            'variant_id', oi.variant_id
          )
          order by oi.id
        )
        from public.order_items oi
        where oi.order_id = o.id
      ),
      '[]'::jsonb
    ) as items
  from public.orders o
  order by o.created_at desc
  limit 100;
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
  if auth.uid() is null or not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Admin access required.'; end if;
  return query select r.id,r.product_id,p.name,r.order_id,r.user_id,r.reviewer_name,o.email,r.rating,r.title,r.review,r.status,r.admin_note,r.created_at,r.updated_at
  from public.product_reviews r join public.products p on p.id=r.product_id join public.orders o on o.id=r.order_id
  order by case r.status when 'pending' then 0 when 'approved' then 1 else 2 end,r.created_at desc;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.list_admin_stock_movements(p_limit integer DEFAULT 100)
 RETURNS TABLE(id uuid, variant_id uuid, product_id uuid, product_name text, size_label text, old_quantity integer, new_quantity integer, quantity_change integer, changed_by uuid, changed_by_name text, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;
  return query
  select sm.id, sm.variant_id, sm.product_id, p.name, v.size_label,
         sm.old_quantity, sm.new_quantity, sm.quantity_change, sm.changed_by,
         pr.full_name, sm.created_at
  from public.stock_movements sm
  join public.product_variants v on v.id = sm.variant_id
  join public.products p on p.id = sm.product_id
  left join public.profiles pr on pr.id = sm.changed_by
  order by sm.created_at desc
  limit greatest(1, least(coalesce(p_limit,100),500));
end;
$function$
;

CREATE OR REPLACE FUNCTION public.list_published_blog_posts()
 RETURNS TABLE(id uuid, title text, slug text, category text, excerpt text, content text, featured_image_url text, is_published boolean, published_at timestamp with time zone, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
 select id,title,slug,category,excerpt,content,featured_image_url,is_published,published_at,created_at,updated_at
 from public.blog_posts
 where is_published=true
 order by published_at desc nulls last, created_at desc;
$function$
;

CREATE OR REPLACE FUNCTION public.list_published_company_pages()
 RETURNS TABLE(page_key text, eyebrow text, title text, intro text, content text, secondary_title text, secondary_content text, is_published boolean, updated_at timestamp with time zone)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select page_key, eyebrow, title, intro, content, secondary_title, secondary_content, is_published, updated_at
  from public.company_pages where is_published=true order by page_key;
$function$
;

CREATE OR REPLACE FUNCTION public.mark_admin_newsletter_campaign_sent(p_id uuid, p_count integer)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
 if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin') then raise exception 'Access denied'; end if;
 update public.newsletter_campaigns set status='sent',sent_count=greatest(p_count,0),sent_at=now() where id=p_id;
end;$function$
;

CREATE OR REPLACE FUNCTION public.mark_order_paid(p_payment_reference text, p_amount_kobo integer)
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
  select * into o from public.orders where payment_reference=p_payment_reference for update;
  if not found then return null; end if;
  if o.payment_status='paid' then return o.id; end if;
  if round(o.total*100)<>p_amount_kobo then raise exception 'Payment amount does not match order total (expected % kobo, received % kobo)',round(o.total*100),p_amount_kobo; end if;

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

  update public.orders set payment_status='paid',status=case when status='pending' then 'processing' else status end,updated_at=now() where id=o.id;
  if o.coupon_code is not null then update public.coupons set used_count=used_count+1,updated_at=now() where upper(code)=upper(o.coupon_code); end if;
  return o.id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.protect_profile_role()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ begin if new.role is distinct from old.role and not public.is_admin() then raise exception 'Only an administrator can change account roles'; end if; return new; end $function$
;

CREATE OR REPLACE FUNCTION public.record_stock_movement()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if new.stock_quantity is distinct from old.stock_quantity then
    insert into public.stock_movements(
      variant_id, product_id, old_quantity, new_quantity, quantity_change, changed_by
    ) values (
      new.id, new.product_id, old.stock_quantity, new.stock_quantity,
      new.stock_quantity - old.stock_quantity, auth.uid()
    );
  end if;
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.release_order_inventory(p_order_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  o public.orders;
  x record;
begin
  select * into o from public.orders where id=p_order_id for update;
  if not found then raise exception 'Order not found'; end if;
  if o.inventory_allocated_at is null or o.inventory_released_at is not null then return o.id; end if;

  for x in select variant_id,product_id,quantity from public.order_items where order_id=o.id loop
    if x.variant_id is not null then
      update public.product_variants set stock_quantity=stock_quantity+x.quantity,updated_at=now() where id=x.variant_id;
    else
      update public.products set stock_quantity=stock_quantity+x.quantity,updated_at=now() where id=x.product_id;
    end if;
  end loop;
  update public.orders set inventory_released_at=now(),updated_at=now() where id=o.id;
  return o.id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.set_my_newsletter_subscription(p_subscribed boolean)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
declare
  v_uid uuid := auth.uid();
  v_email text;
  v_name text;
begin
  if v_uid is null then
    raise exception 'Authentication required';
  end if;

  select u.email, coalesce(p.full_name, u.raw_user_meta_data->>'full_name')
    into v_email, v_name
  from auth.users u
  left join public.profiles p on p.id = u.id
  where u.id = v_uid;

  if v_email is null or btrim(v_email) = '' then
    raise exception 'Account email is unavailable';
  end if;

  if p_subscribed then
    insert into public.newsletter_subscribers(user_id,email,full_name,status,source,consent_at,unsubscribed_at,updated_at)
    values(v_uid,lower(v_email),nullif(btrim(coalesce(v_name,'')),''),'subscribed','account',now(),null,now())
    on conflict (lower(email)) do update
      set user_id = excluded.user_id,
          full_name = coalesce(excluded.full_name, public.newsletter_subscribers.full_name),
          status = 'subscribed',
          source = 'account',
          consent_at = now(),
          unsubscribed_at = null,
          updated_at = now();
    return true;
  end if;

  update public.newsletter_subscribers
     set user_id = coalesce(user_id,v_uid),
         status = 'unsubscribed',
         unsubscribed_at = now(),
         updated_at = now()
   where user_id = v_uid or lower(email) = lower(v_email);
  return false;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.set_user_role(p_user_id uuid, p_role text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
begin
  if not public.is_admin() then raise exception 'Administrator access required'; end if;
  if p_role not in ('admin','customer') then raise exception 'Invalid role'; end if;
  if p_user_id = auth.uid() and p_role <> 'admin' then raise exception 'You cannot remove your own administrator access'; end if;
  if not exists(select 1 from auth.users where id=p_user_id) then raise exception 'User not found'; end if;
  update public.profiles set role=p_role where id=p_user_id;
  if not found then raise exception 'Profile not found'; end if;
  return true;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.submit_product_review(p_order_id uuid, p_product_id uuid, p_rating integer, p_title text, p_review text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_review_id uuid;
  v_name text;
begin
  if v_user_id is null then raise exception 'Please sign in to submit your review.'; end if;
  if p_rating not between 1 and 5 then raise exception 'Rating must be between 1 and 5.'; end if;
  if char_length(trim(coalesce(p_review,''))) not between 10 and 2000 then raise exception 'Review must contain between 10 and 2000 characters.'; end if;
  if char_length(trim(coalesce(p_title,''))) > 120 then raise exception 'Review title is too long.'; end if;

  if not exists (
    select 1 from public.orders o
    where o.id = p_order_id
      and o.user_id = v_user_id
      and (o.payment_status = 'paid' or o.status = 'delivered')
      and exists (
        select 1 from public.order_items item
        where item.order_id = o.id and item.product_id = p_product_id
      )
  ) then
    raise exception 'Only customers who purchased this product can review it.';
  end if;

  select nullif(trim(p.full_name),'') into v_name from public.profiles p where p.id = v_user_id;

  insert into public.product_reviews(product_id,order_id,user_id,rating,title,review,reviewer_name,status,updated_at,moderated_at,moderated_by,admin_note)
  values(p_product_id,p_order_id,v_user_id,p_rating,nullif(trim(coalesce(p_title,'')),''),trim(p_review),coalesce(v_name,'Verified customer'),'pending',now(),null,null,null)
  on conflict(order_id,product_id,user_id) do update set
    rating=excluded.rating,title=excluded.title,review=excluded.review,reviewer_name=excluded.reviewer_name,
    status='pending',updated_at=now(),moderated_at=null,moderated_by=null,admin_note=null
  returning id into v_review_id;
  return v_review_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.subscribe_newsletter(p_email text, p_full_name text DEFAULT NULL::text, p_source text DEFAULT 'website'::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_email text := lower(trim(p_email));
begin
  if v_email = '' or position('@' in v_email) < 2 then raise exception 'A valid email address is required.'; end if;
  update public.newsletter_subscribers
     set full_name = coalesce(nullif(trim(p_full_name),''), full_name),
         status='subscribed', source=coalesce(nullif(trim(p_source),''),'website'),
         consent_at=now(), unsubscribed_at=null, updated_at=now()
   where lower(email)=v_email;
  if not found then
    insert into public.newsletter_subscribers(email,full_name,status,source,user_id)
    values(v_email,nullif(trim(p_full_name),''),'subscribed',coalesce(nullif(trim(p_source),''),'website'),auth.uid());
  end if;
end;$function$
;

CREATE OR REPLACE FUNCTION public.touch_product_variants_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.unsubscribe_newsletter(p_token uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
 update public.newsletter_subscribers set status='unsubscribed',unsubscribed_at=now(),updated_at=now() where unsubscribe_token=p_token;
end;$function$
;

CREATE OR REPLACE FUNCTION public.validate_coupon(p_code text, p_subtotal numeric)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ declare c public.coupons; d numeric; begin select * into c from public.coupons where upper(code)=upper(trim(p_code)) and is_active=true; if not found then return jsonb_build_object('valid',false,'message','Coupon not found or inactive'); end if; if c.starts_at is not null and now()<c.starts_at then return jsonb_build_object('valid',false,'message','Coupon is not active yet'); end if; if c.expires_at is not null and now()>c.expires_at then return jsonb_build_object('valid',false,'message','Coupon has expired'); end if; if c.max_uses is not null and c.used_count>=c.max_uses then return jsonb_build_object('valid',false,'message','Coupon usage limit reached'); end if; if p_subtotal<c.minimum_order then return jsonb_build_object('valid',false,'message','Minimum order value not reached'); end if; d:=case when c.discount_type='percentage' then least(p_subtotal,p_subtotal*c.discount_value/100) else least(p_subtotal,c.discount_value) end; return jsonb_build_object('valid',true,'code',c.code,'discount',round(d,2),'discount_type',c.discount_type,'discount_value',c.discount_value); end $function$
;

ALTER TABLE public."profiles" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."profiles" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."profiles" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."profiles" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."profiles" TO authenticated;

ALTER TABLE public."categories" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."categories" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."categories" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."categories" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."categories" TO authenticated;

ALTER TABLE public."products" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."products" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."products" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."products" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."products" TO authenticated;

ALTER TABLE public."order_items" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."order_items" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."order_items" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."order_items" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."order_items" TO authenticated;

ALTER TABLE public."product_variants" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."product_variants" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."product_variants" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."product_variants" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."product_variants" TO authenticated;

ALTER TABLE public."storefront_content" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."storefront_content" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."storefront_content" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."storefront_content" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."storefront_content" TO authenticated;

ALTER TABLE public."coupons" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."coupons" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."coupons" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."coupons" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."coupons" TO authenticated;

ALTER TABLE public."newsletter_subscribers" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."newsletter_subscribers" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."newsletter_subscribers" TO service_role;

ALTER TABLE public."blog_posts" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."blog_posts" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."blog_posts" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."blog_posts" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."blog_posts" TO authenticated;

ALTER TABLE public."content_pages" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."content_pages" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."content_pages" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."content_pages" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."content_pages" TO authenticated;

ALTER TABLE public."company_pages" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."company_pages" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."company_pages" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."company_pages" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."company_pages" TO authenticated;

ALTER TABLE public."orders" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."orders" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."orders" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."orders" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."orders" TO authenticated;

ALTER TABLE public."homepage_sections" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."homepage_sections" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."homepage_sections" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."homepage_sections" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."homepage_sections" TO authenticated;

ALTER TABLE public."newsletter_campaigns" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."newsletter_campaigns" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."newsletter_campaigns" TO service_role;

ALTER TABLE public."stock_movements" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."stock_movements" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."stock_movements" TO service_role;

ALTER TABLE public."newsletter_events" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."newsletter_events" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."newsletter_events" TO service_role;

ALTER TABLE public."order_email_log" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."order_email_log" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."order_email_log" TO service_role;

ALTER TABLE public."ai_agent_integrations" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_integrations" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_integrations" TO service_role;

ALTER TABLE public."ai_agent_threads" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_threads" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_threads" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_threads" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_threads" TO authenticated;

ALTER TABLE public."ai_agent_messages" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_messages" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_messages" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_messages" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_messages" TO authenticated;

ALTER TABLE public."ai_agent_tasks" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_tasks" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_tasks" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_tasks" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_tasks" TO authenticated;

ALTER TABLE public."ai_agent_approvals" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_approvals" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_approvals" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_approvals" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_approvals" TO authenticated;

ALTER TABLE public."ai_agent_activity" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."ai_agent_activity" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."ai_agent_activity" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_activity" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."ai_agent_activity" TO authenticated;

ALTER TABLE public."product_reviews" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public."product_reviews" FROM PUBLIC, anon, authenticated;

GRANT ALL ON public."product_reviews" TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."product_reviews" TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public."product_reviews" TO authenticated;

REVOKE ALL ON FUNCTION public."admin_bulk_update_variant_stock"(p_updates jsonb) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_bulk_update_variant_stock"(p_updates jsonb) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_bulk_update_variant_stock"(p_updates jsonb) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_create_product_with_variants"(p_product jsonb, p_variants jsonb) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_create_product_with_variants"(p_product jsonb, p_variants jsonb) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_create_product_with_variants"(p_product jsonb, p_variants jsonb) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_manage_content"(p_type text, p_id uuid, p_action text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_manage_content"(p_type text, p_id uuid, p_action text) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_manage_content"(p_type text, p_id uuid, p_action text) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_moderate_product_review"(p_review_id uuid, p_status text, p_admin_note text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_moderate_product_review"(p_review_id uuid, p_status text, p_admin_note text) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_moderate_product_review"(p_review_id uuid, p_status text, p_admin_note text) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_update_content"(p_type text, p_id uuid, p_payload jsonb) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_update_content"(p_type text, p_id uuid, p_payload jsonb) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_update_content"(p_type text, p_id uuid, p_payload jsonb) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_update_order_status"(p_order_id uuid, p_status text, p_payment_status text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_update_order_status"(p_order_id uuid, p_status text, p_payment_status text) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_update_order_status"(p_order_id uuid, p_status text, p_payment_status text) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_update_reorder_threshold"(p_variant_id uuid, p_threshold integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_update_reorder_threshold"(p_variant_id uuid, p_threshold integer) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_update_reorder_threshold"(p_variant_id uuid, p_threshold integer) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_update_variant_stock"(p_variant_id uuid, p_stock integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_update_variant_stock"(p_variant_id uuid, p_stock integer) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_update_variant_stock"(p_variant_id uuid, p_stock integer) TO authenticated;

REVOKE ALL ON FUNCTION public."admin_upsert_product_variant"(p_product_id uuid, p_variant_id uuid, p_size_label text, p_size_grams integer, p_price numeric, p_stock integer, p_is_active boolean) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."admin_upsert_product_variant"(p_product_id uuid, p_variant_id uuid, p_size_label text, p_size_grams integer, p_price numeric, p_stock integer, p_is_active boolean) TO service_role;

GRANT EXECUTE ON FUNCTION public."admin_upsert_product_variant"(p_product_id uuid, p_variant_id uuid, p_size_label text, p_size_grams integer, p_price numeric, p_stock integer, p_is_active boolean) TO authenticated;

REVOKE ALL ON FUNCTION public."allocate_order_inventory"(p_order_id uuid) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."allocate_order_inventory"(p_order_id uuid) TO service_role;

REVOKE ALL ON FUNCTION public."apply_coupon_to_order"(p_order_id uuid, p_code text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."apply_coupon_to_order"(p_order_id uuid, p_code text) TO service_role;

REVOKE ALL ON FUNCTION public."confirm_pay_after_delivery_order"(p_order_id uuid) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."confirm_pay_after_delivery_order"(p_order_id uuid) TO service_role;

GRANT EXECUTE ON FUNCTION public."confirm_pay_after_delivery_order"(p_order_id uuid) TO authenticated;

REVOKE ALL ON FUNCTION public."create_admin_newsletter_campaign"(p_subject text, p_preview_text text, p_body_html text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."create_admin_newsletter_campaign"(p_subject text, p_preview_text text, p_body_html text) TO service_role;

GRANT EXECUTE ON FUNCTION public."create_admin_newsletter_campaign"(p_subject text, p_preview_text text, p_body_html text) TO authenticated;

REVOKE ALL ON FUNCTION public."create_checkout_order"(p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."create_checkout_order"(p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text) TO service_role;

REVOKE ALL ON FUNCTION public."create_checkout_order_v2"(p_user_id uuid, p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."create_checkout_order_v2"(p_user_id uuid, p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text) TO service_role;

GRANT EXECUTE ON FUNCTION public."create_checkout_order_v2"(p_user_id uuid, p_email text, p_phone text, p_delivery_address text, p_delivery_zone text, p_items jsonb, p_payment_reference text, p_customer_name text, p_payment_method text) TO authenticated;

REVOKE ALL ON FUNCTION public."create_pending_order"(p_email text, p_phone text, p_delivery_address text, p_items jsonb, p_payment_reference text, p_customer_name text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."create_pending_order"(p_email text, p_phone text, p_delivery_address text, p_items jsonb, p_payment_reference text, p_customer_name text) TO service_role;

REVOKE ALL ON FUNCTION public."get_admin_management_reports"(p_from timestamp with time zone, p_to timestamp with time zone) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_admin_management_reports"(p_from timestamp with time zone, p_to timestamp with time zone) TO service_role;

GRANT EXECUTE ON FUNCTION public."get_admin_management_reports"(p_from timestamp with time zone, p_to timestamp with time zone) TO authenticated;

REVOKE ALL ON FUNCTION public."get_admin_newsletter_event_summary"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_admin_newsletter_event_summary"() TO service_role;

GRANT EXECUTE ON FUNCTION public."get_admin_newsletter_event_summary"() TO authenticated;

REVOKE ALL ON FUNCTION public."get_admin_newsletter_events"(p_limit integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_admin_newsletter_events"(p_limit integer) TO service_role;

GRANT EXECUTE ON FUNCTION public."get_admin_newsletter_events"(p_limit integer) TO authenticated;

REVOKE ALL ON FUNCTION public."get_admin_sales_analytics"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_admin_sales_analytics"() TO service_role;

GRANT EXECUTE ON FUNCTION public."get_admin_sales_analytics"() TO authenticated;

REVOKE ALL ON FUNCTION public."get_my_admin_status"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_my_admin_status"() TO service_role;

GRANT EXECUTE ON FUNCTION public."get_my_admin_status"() TO authenticated;

REVOKE ALL ON FUNCTION public."get_my_checkout_order"(p_order_id uuid) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_my_checkout_order"(p_order_id uuid) TO service_role;

GRANT EXECUTE ON FUNCTION public."get_my_checkout_order"(p_order_id uuid) TO authenticated;

REVOKE ALL ON FUNCTION public."get_my_newsletter_preference"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_my_newsletter_preference"() TO service_role;

GRANT EXECUTE ON FUNCTION public."get_my_newsletter_preference"() TO authenticated;

REVOKE ALL ON FUNCTION public."get_my_orders"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_my_orders"() TO service_role;

GRANT EXECUTE ON FUNCTION public."get_my_orders"() TO authenticated;

REVOKE ALL ON FUNCTION public."get_public_product_detail"(p_slug text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."get_public_product_detail"(p_slug text) TO service_role;

GRANT EXECUTE ON FUNCTION public."get_public_product_detail"(p_slug text) TO anon;

GRANT EXECUTE ON FUNCTION public."get_public_product_detail"(p_slug text) TO authenticated;

REVOKE ALL ON FUNCTION public."handle_new_user"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."handle_new_user"() TO service_role;

REVOKE ALL ON FUNCTION public."is_admin"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."is_admin"() TO service_role;

GRANT EXECUTE ON FUNCTION public."is_admin"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_blog_posts"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_blog_posts"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_blog_posts"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_catalogue_categories"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_categories"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_categories"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_catalogue_products"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_products"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_products"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_catalogue_variants"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_variants"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_catalogue_variants"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_company_pages"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_company_pages"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_company_pages"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_content_pages"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_content_pages"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_content_pages"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_customer_crm"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_customer_crm"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_customer_crm"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_customer_profiles"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_customer_profiles"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_customer_profiles"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_homepage_sections"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_homepage_sections"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_homepage_sections"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_manageable_users"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_manageable_users"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_manageable_users"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_newsletter_campaigns"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_newsletter_campaigns"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_newsletter_campaigns"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_newsletter_subscribers"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_newsletter_subscribers"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_newsletter_subscribers"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_order_email_history"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_order_email_history"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_order_email_history"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_orders"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_orders"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_orders"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_product_reviews"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_product_reviews"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_product_reviews"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_admin_stock_movements"(p_limit integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_admin_stock_movements"(p_limit integer) TO service_role;

GRANT EXECUTE ON FUNCTION public."list_admin_stock_movements"(p_limit integer) TO authenticated;

REVOKE ALL ON FUNCTION public."list_published_blog_posts"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_published_blog_posts"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_published_blog_posts"() TO anon;

GRANT EXECUTE ON FUNCTION public."list_published_blog_posts"() TO authenticated;

REVOKE ALL ON FUNCTION public."list_published_company_pages"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."list_published_company_pages"() TO service_role;

GRANT EXECUTE ON FUNCTION public."list_published_company_pages"() TO anon;

GRANT EXECUTE ON FUNCTION public."list_published_company_pages"() TO authenticated;

REVOKE ALL ON FUNCTION public."mark_admin_newsletter_campaign_sent"(p_id uuid, p_count integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."mark_admin_newsletter_campaign_sent"(p_id uuid, p_count integer) TO service_role;

GRANT EXECUTE ON FUNCTION public."mark_admin_newsletter_campaign_sent"(p_id uuid, p_count integer) TO authenticated;

REVOKE ALL ON FUNCTION public."mark_order_paid"(p_payment_reference text, p_amount_kobo integer) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."mark_order_paid"(p_payment_reference text, p_amount_kobo integer) TO service_role;

REVOKE ALL ON FUNCTION public."protect_profile_role"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."protect_profile_role"() TO service_role;

REVOKE ALL ON FUNCTION public."record_stock_movement"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."record_stock_movement"() TO service_role;

REVOKE ALL ON FUNCTION public."release_order_inventory"(p_order_id uuid) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."release_order_inventory"(p_order_id uuid) TO service_role;

REVOKE ALL ON FUNCTION public."set_my_newsletter_subscription"(p_subscribed boolean) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."set_my_newsletter_subscription"(p_subscribed boolean) TO service_role;

GRANT EXECUTE ON FUNCTION public."set_my_newsletter_subscription"(p_subscribed boolean) TO authenticated;

REVOKE ALL ON FUNCTION public."set_user_role"(p_user_id uuid, p_role text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."set_user_role"(p_user_id uuid, p_role text) TO service_role;

GRANT EXECUTE ON FUNCTION public."set_user_role"(p_user_id uuid, p_role text) TO authenticated;

REVOKE ALL ON FUNCTION public."submit_product_review"(p_order_id uuid, p_product_id uuid, p_rating integer, p_title text, p_review text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."submit_product_review"(p_order_id uuid, p_product_id uuid, p_rating integer, p_title text, p_review text) TO service_role;

GRANT EXECUTE ON FUNCTION public."submit_product_review"(p_order_id uuid, p_product_id uuid, p_rating integer, p_title text, p_review text) TO authenticated;

REVOKE ALL ON FUNCTION public."subscribe_newsletter"(p_email text, p_full_name text, p_source text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."subscribe_newsletter"(p_email text, p_full_name text, p_source text) TO service_role;

GRANT EXECUTE ON FUNCTION public."subscribe_newsletter"(p_email text, p_full_name text, p_source text) TO anon;

GRANT EXECUTE ON FUNCTION public."subscribe_newsletter"(p_email text, p_full_name text, p_source text) TO authenticated;

REVOKE ALL ON FUNCTION public."touch_product_variants_updated_at"() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."touch_product_variants_updated_at"() TO service_role;

GRANT EXECUTE ON FUNCTION public."touch_product_variants_updated_at"() TO anon;

GRANT EXECUTE ON FUNCTION public."touch_product_variants_updated_at"() TO authenticated;

REVOKE ALL ON FUNCTION public."unsubscribe_newsletter"(p_token uuid) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."unsubscribe_newsletter"(p_token uuid) TO service_role;

GRANT EXECUTE ON FUNCTION public."unsubscribe_newsletter"(p_token uuid) TO anon;

GRANT EXECUTE ON FUNCTION public."unsubscribe_newsletter"(p_token uuid) TO authenticated;

REVOKE ALL ON FUNCTION public."validate_coupon"(p_code text, p_subtotal numeric) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public."validate_coupon"(p_code text, p_subtotal numeric) TO service_role;

GRANT EXECUTE ON FUNCTION public."validate_coupon"(p_code text, p_subtotal numeric) TO anon;

GRANT EXECUTE ON FUNCTION public."validate_coupon"(p_code text, p_subtotal numeric) TO authenticated;

CREATE INDEX products_category_id_idx ON public.products USING btree (category_id);

CREATE INDEX products_active_idx ON public.products USING btree (is_active);

CREATE INDEX order_items_order_id_idx ON public.order_items USING btree (order_id);

CREATE INDEX order_items_variant_id_idx ON public.order_items USING btree (variant_id);

CREATE INDEX order_items_product_id_idx ON public.order_items USING btree (product_id);

CREATE INDEX product_variants_product_id_idx ON public.product_variants USING btree (product_id);

CREATE INDEX product_variants_stock_threshold_idx ON public.product_variants USING btree (stock_quantity, reorder_threshold) WHERE (is_active = true);

CREATE UNIQUE INDEX newsletter_subscribers_email_lower_idx ON public.newsletter_subscribers USING btree (lower(email));

CREATE UNIQUE INDEX newsletter_subscribers_unsubscribe_token_idx ON public.newsletter_subscribers USING btree (unsubscribe_token);

CREATE INDEX newsletter_subscribers_user_id_idx ON public.newsletter_subscribers USING btree (user_id);

CREATE INDEX orders_user_id_idx ON public.orders USING btree (user_id);

CREATE INDEX orders_status_idx ON public.orders USING btree (status);

CREATE INDEX newsletter_campaigns_created_by_idx ON public.newsletter_campaigns USING btree (created_by);

CREATE INDEX stock_movements_variant_created_idx ON public.stock_movements USING btree (variant_id, created_at DESC);

CREATE INDEX stock_movements_product_created_idx ON public.stock_movements USING btree (product_id, created_at DESC);

CREATE INDEX newsletter_events_email_id_idx ON public.newsletter_events USING btree (resend_email_id);

CREATE INDEX newsletter_events_type_idx ON public.newsletter_events USING btree (event_type);

CREATE INDEX newsletter_events_event_at_idx ON public.newsletter_events USING btree (event_at DESC);

CREATE INDEX newsletter_events_campaign_id_idx ON public.newsletter_events USING btree (campaign_id);

CREATE INDEX order_email_log_order_idx ON public.order_email_log USING btree (order_id, created_at DESC);

CREATE INDEX ai_agent_integrations_provider_idx ON public.ai_agent_integrations USING btree (provider);

CREATE UNIQUE INDEX ai_agent_integrations_provider_account_key_uidx ON public.ai_agent_integrations USING btree (provider, account_key);

CREATE INDEX ai_agent_messages_thread_created_idx ON public.ai_agent_messages USING btree (thread_id, created_at);

CREATE INDEX ai_agent_tasks_status_due_idx ON public.ai_agent_tasks USING btree (status, due_at);

CREATE INDEX ai_agent_approvals_status_created_idx ON public.ai_agent_approvals USING btree (status, created_at);

CREATE INDEX ai_agent_activity_created_idx ON public.ai_agent_activity USING btree (created_at DESC);

CREATE INDEX product_reviews_public_idx ON public.product_reviews USING btree (product_id, created_at DESC) WHERE (status = 'approved'::text);

CREATE INDEX product_reviews_moderation_idx ON public.product_reviews USING btree (status, created_at DESC);

CREATE INDEX product_reviews_user_id_idx ON public.product_reviews USING btree (user_id);

CREATE INDEX product_reviews_moderated_by_idx ON public.product_reviews USING btree (moderated_by) WHERE (moderated_by IS NOT NULL);

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();

CREATE TRIGGER product_variants_updated_at BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION touch_product_variants_updated_at();

CREATE TRIGGER protect_profile_role_trigger BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION protect_profile_role();

CREATE TRIGGER product_variant_stock_movement_trigger AFTER UPDATE OF stock_quantity ON public.product_variants FOR EACH ROW EXECUTE FUNCTION record_stock_movement();

CREATE POLICY "product_variants_public_read" ON "public"."product_variants" AS PERMISSIVE FOR SELECT TO "anon", "authenticated" USING ((is_active = true));

CREATE POLICY "profiles_select_own" ON "public"."profiles" AS PERMISSIVE FOR SELECT TO "authenticated" USING (((id = ( SELECT auth.uid() AS uid)) OR ( SELECT is_admin() AS is_admin)));

CREATE POLICY "orders_own_insert" ON "public"."orders" AS PERMISSIVE FOR INSERT TO "authenticated" WITH CHECK ((user_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "Admins can upload product images" ON "storage"."objects" AS PERMISSIVE FOR INSERT TO "authenticated" WITH CHECK (((bucket_id = 'product-images'::text) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))));

CREATE POLICY "Admins can update product images" ON "storage"."objects" AS PERMISSIVE FOR UPDATE TO "authenticated" USING (((bucket_id = 'product-images'::text) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))))) WITH CHECK (((bucket_id = 'product-images'::text) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))));

CREATE POLICY "Admins can delete product images" ON "storage"."objects" AS PERMISSIVE FOR DELETE TO "authenticated" USING (((bucket_id = 'product-images'::text) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))));

CREATE POLICY "products_public_read" ON "public"."products" AS PERMISSIVE FOR SELECT TO "anon", "authenticated" USING ((is_active = true));

CREATE POLICY "categories_public_read" ON "public"."categories" AS PERMISSIVE FOR SELECT TO "anon", "authenticated" USING (true);

CREATE POLICY "public can read storefront content" ON "public"."storefront_content" AS PERMISSIVE FOR SELECT TO "anon", "authenticated" USING (true);

CREATE POLICY "Public can read published content pages" ON "public"."content_pages" AS PERMISSIVE FOR SELECT TO "public" USING (((is_published = true) OR is_admin()));

CREATE POLICY "Admins manage content pages" ON "public"."content_pages" AS PERMISSIVE FOR ALL TO "public" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "profiles_update_own" ON "public"."profiles" AS PERMISSIVE FOR UPDATE TO "authenticated" USING ((id = ( SELECT auth.uid() AS uid))) WITH CHECK (((id = ( SELECT auth.uid() AS uid)) AND (role = ( SELECT p.role
   FROM profiles p
  WHERE (p.id = ( SELECT auth.uid() AS uid))))));

CREATE POLICY "admins can update storefront content" ON "public"."storefront_content" AS PERMISSIVE FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))));

CREATE POLICY "coupons_admin_all" ON "public"."coupons" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "company_pages_public_read" ON "public"."company_pages" AS PERMISSIVE FOR SELECT TO "public" USING (((is_published = true) OR is_admin()));

CREATE POLICY "company_pages_admin_write" ON "public"."company_pages" AS PERMISSIVE FOR ALL TO "public" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "blog_posts_public_read" ON "public"."blog_posts" AS PERMISSIVE FOR SELECT TO "public" USING (((is_published = true) OR is_admin()));

CREATE POLICY "blog_posts_admin_write" ON "public"."blog_posts" AS PERMISSIVE FOR ALL TO "public" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Public can read published homepage sections" ON "public"."homepage_sections" AS PERMISSIVE FOR SELECT TO "public" USING (((is_published = true) OR is_admin()));

CREATE POLICY "Admins manage homepage sections" ON "public"."homepage_sections" AS PERMISSIVE FOR ALL TO "public" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "profiles_admin_update" ON "public"."profiles" AS PERMISSIVE FOR UPDATE TO "authenticated" USING (( SELECT is_admin() AS is_admin)) WITH CHECK (( SELECT is_admin() AS is_admin));

CREATE POLICY "orders_own_read" ON "public"."orders" AS PERMISSIVE FOR SELECT TO "authenticated" USING (((user_id = ( SELECT auth.uid() AS uid)) OR ( SELECT is_admin() AS is_admin)));

CREATE POLICY "orders_admin_all" ON "public"."orders" AS PERMISSIVE FOR ALL TO "authenticated" USING (( SELECT is_admin() AS is_admin)) WITH CHECK (( SELECT is_admin() AS is_admin));

CREATE POLICY "order_items_own_insert" ON "public"."order_items" AS PERMISSIVE FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM orders o
  WHERE ((o.id = order_items.order_id) AND (o.user_id = ( SELECT auth.uid() AS uid))))));

CREATE POLICY "order_items_own_read" ON "public"."order_items" AS PERMISSIVE FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM orders o
  WHERE ((o.id = order_items.order_id) AND ((o.user_id = ( SELECT auth.uid() AS uid)) OR ( SELECT is_admin() AS is_admin))))));

CREATE POLICY "order_items_admin_all" ON "public"."order_items" AS PERMISSIVE FOR ALL TO "authenticated" USING (( SELECT is_admin() AS is_admin)) WITH CHECK (( SELECT is_admin() AS is_admin));

CREATE POLICY "categories_admin_write" ON "public"."categories" AS PERMISSIVE FOR ALL TO "authenticated" USING (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists")) WITH CHECK (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists"));

CREATE POLICY "products_admin_write" ON "public"."products" AS PERMISSIVE FOR ALL TO "authenticated" USING (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists")) WITH CHECK (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists"));

CREATE POLICY "product_variants_admin_write" ON "public"."product_variants" AS PERMISSIVE FOR ALL TO "authenticated" USING (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists")) WITH CHECK (( SELECT (EXISTS ( SELECT 1
           FROM profiles
          WHERE ((profiles.id = ( SELECT auth.uid() AS uid)) AND (profiles.role = 'admin'::text)))) AS "exists"));

CREATE POLICY "Admins can read product images" ON "storage"."objects" AS PERMISSIVE FOR SELECT TO "authenticated" USING (((bucket_id = 'product-images'::text) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))));

CREATE POLICY "admins manage ai threads" ON "public"."ai_agent_threads" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "admins manage ai messages" ON "public"."ai_agent_messages" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "admins manage ai tasks" ON "public"."ai_agent_tasks" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "admins manage ai approvals" ON "public"."ai_agent_approvals" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "admins manage ai activity" ON "public"."ai_agent_activity" AS PERMISSIVE FOR ALL TO "authenticated" USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Approved reviews are public" ON "public"."product_reviews" AS PERMISSIVE FOR SELECT TO "anon" USING ((status = 'approved'::text));

CREATE POLICY "Customers can read visible or owned reviews" ON "public"."product_reviews" AS PERMISSIVE FOR SELECT TO "authenticated" USING (((status = 'approved'::text) OR (( SELECT auth.uid() AS uid) = user_id)));

INSERT INTO storage.buckets(id,name,public,file_size_limit,allowed_mime_types) VALUES ('product-images','product-images',true,5242880,ARRAY['image/jpeg','image/png','image/webp','image/gif']);
