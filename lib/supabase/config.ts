// Public project values. Server secrets are configured only in Vercel.
// Both Folus websites use the main project for one shared customer/admin identity.
export const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://boaaiskncrfmaismhqno.supabase.co'
export const SUPABASE_PUBLISHABLE_KEY = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_SQQVr7OX77UswU1WadKsSA_dSV1jeNi'
