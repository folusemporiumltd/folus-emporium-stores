INSERT INTO public.categories(name,slug,description) VALUES
('Kitchen Appliances','kitchen-appliances','Practical appliances for preparing and enjoying meals.'),
('Souvenirs & Gifts','souvenirs-gifts','Thoughtful gifts and keepsakes for special occasions.'),
('Food & Beverages','food-beverages','Food, drinks and pantry favourites for everyday living.'),
('Hygiene & Personal Care','hygiene-personal-care','Everyday essentials for personal and household care.'),
('Health & Beauty','health-beauty','Beauty and self-care products for your daily routine.'),
('Fashion, Accessories & Apparel','fashion-accessories-apparel','Clothing and accessories for your personal style.'),
('Home Appliances','home-appliances','Useful appliances for a comfortable, well-equipped home.');
INSERT INTO public.storefront_content(id,config) VALUES(true,'{"announcement":"Everyday essentials and thoughtful gifts, delivered across Nigeria.","utilityLinks":[["Track Order","/account"],["FAQ","/faq"],["Contact Us","/contact"]],"navigation":[["Home","/"],["Shop","/shop"],["Categories","/#categories"],["About Us","/about"],["Contact Us","/contact"]],"social":{"facebook":"https://www.facebook.com/folusemporiumltd","tiktok":"https://www.tiktok.com/@folusemporium25","whatsapp":"https://wa.me/2349168157255"},"slides":[],"trust":[["Quality Products","Selected with care","shield"],["Everyday Convenience","Shop in one place","leaf"],["Delivery","Across Nigeria","truck"],["Customer Support","We are here to help","support"]]}'::jsonb);
INSERT INTO public.company_pages(page_key,eyebrow,title,intro,content,secondary_title,secondary_content) VALUES
('about','About Folus Emporium Stores','Everyday essentials, thoughtfully selected.','Folus Emporium Stores brings together practical products for homes, personal care, style and celebrations.','Explore kitchen and home appliances, souvenirs and gifts, food and beverages, hygiene and personal care, health and beauty, fashion, accessories and apparel.','Our promise','Curating Excellence for Life’s Finest Moments. We aim to make shopping simple, with clear product information and helpful service.'),
('story','Our story','Useful products. Thoughtful service.','Folus Emporium Stores is part of Folus Emporium Ltd, based in Ibadan, Oyo State.','The store brings our home, lifestyle and gifting collections together so customers can find what they need in one place.','Built around your needs','Our collection grows as we listen to what our customers need for their homes, businesses and special occasions.'),
('careers','Careers','Grow with Folus Emporium Stores.','We value practical skills, dependable service and a willingness to learn.','Openings will be published when positions become available.','Current openings','No publicly advertised vacancy at the moment.');
ALTER TABLE public.products ALTER COLUMN default_size_grams SET DEFAULT 1;
-- Checkout mutations must use the validated functions, not direct table inserts.
DROP POLICY orders_own_insert ON public.orders;
DROP POLICY order_items_own_insert ON public.order_items;
-- Anonymous visitors can read published content without evaluating an admin helper.
DROP POLICY "company_pages_public_read" ON public.company_pages;
CREATE POLICY "company_pages_public_read" ON public.company_pages FOR SELECT TO anon, authenticated USING (is_published=true);
ALTER POLICY "company_pages_admin_write" ON public.company_pages TO authenticated;
DROP POLICY "blog_posts_public_read" ON public.blog_posts;
CREATE POLICY "blog_posts_public_read" ON public.blog_posts FOR SELECT TO anon, authenticated USING (is_published=true);
ALTER POLICY "blog_posts_admin_write" ON public.blog_posts TO authenticated;
DROP POLICY "Public can read published content pages" ON public.content_pages;
CREATE POLICY "Public can read published content pages" ON public.content_pages FOR SELECT TO anon, authenticated USING (is_published=true);
ALTER POLICY "Admins manage content pages" ON public.content_pages TO authenticated;
DROP POLICY "Public can read published homepage sections" ON public.homepage_sections;
CREATE POLICY "Public can read published homepage sections" ON public.homepage_sections FOR SELECT TO anon, authenticated USING (is_published=true);
ALTER POLICY "Admins manage homepage sections" ON public.homepage_sections TO authenticated;
