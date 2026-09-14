# Folus Emporium Stores

A separate Next.js storefront adapted from folusemporiumltd/website (source tree 99ae34654d023b55d84e4873e42d229a64cc80b3).

## Included
Public catalogue, seven categories, search, filters, wishlist, cart, customer accounts, password changes, Paystack checkout, delivery options, order tracking, admin dashboard, product options and stock, coupons, reviews with moderation, purchase thank-you emails, newsletters, CMS, reports and assistant/integration pages.

Product option labels support capacity, clothing size, colour, pack count or weight. The inherited database fields size_grams/default_size_grams serve as internal numeric option keys in this store; they are not displayed as weights. The admin assigns these keys automatically. The first option is the initial default.

## Projects
- GitHub: https://github.com/folusemporiumltd/folus-emporium-stores
- Supabase: vzrgjwhkeezojkgxpirn
- Expected site URL: https://folus-emporium-stores-online.vercel.app (set NEXT_PUBLIC_SITE_URL to the actual domain)

## Setup
1. Import this repository into Vercel with the Next.js framework.
2. Configure variables from .env.example. Public Supabase values default to this store's project.
3. Set SUPABASE_SERVICE_ROLE_KEY from the NEW Supabase project. Keep it server-side.
4. Start with Paystack test credentials. Configure its webhook at /api/paystack/webhook.
5. Set BREVO_API_KEY and verified sender addresses. Use a dedicated Brevo list and store-specific welcome template IDs. No old list or template is used by default.
6. Set the Supabase Auth Site URL to the deployed store and allow its /auth/callback and /auth/reset-callback URLs.
7. Register the store owner's account, then grant that verified account the admin role through Supabase. No admin or customer account is copied.
8. Add products, real prices and stock in /admin/products.
9. Test registration, password recovery, checkout, payment confirmation, review moderation and email delivery before accepting live orders.

The schema and category migrations are already applied to the new Supabase project. They contain structure and store content only; customer records, orders, credentials, coupons and subscriber lists were not copied.

Optional integrations use OPENAI_API_KEY, OPENAI_AGENT_MODEL, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, ZOHO_CLIENT_ID, ZOHO_CLIENT_SECRET, ZOHO_ACCOUNTS_DOMAIN and NEXT_PUBLIC_GA_MEASUREMENT_ID. Connect them separately for this store.

## Development
npm install
npm run dev

## Verification
npm run build

External payment and email flows require configured credentials and end-to-end testing. A successful build does not verify these integrations.
