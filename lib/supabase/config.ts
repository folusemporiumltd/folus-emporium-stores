// Authentication is centralized in the main Folus project so existing
// customers and administrators can use one account on both websites.
export const SUPABASE_URL = 'https://boaaiskncrfmaismhqno.supabase.co'
export const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_SQQVr7OX77UswU1WadKsSA_dSV1jeNi'

// Public catalogue reads remain on the original Store project during the
// staged database migration, preventing any interruption to the storefront.
export const CATALOGUE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://vzrgjwhkeezojkgxpirn.supabase.co'
export const CATALOGUE_PUBLISHABLE_KEY = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_EulfIYv6gVJAP8vzb-v1_A_8Lz_-EzC'
