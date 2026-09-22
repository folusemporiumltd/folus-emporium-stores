import { createClient } from '@supabase/supabase-js'

/** Server-only Supabase client. Never import this module into client components. */
export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  if (!url || !serviceRoleKey) throw new Error('Supabase server credentials are not configured.')
  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
}

/** Store data access after the caller has passed an administrator check against shared auth. */
export function createStoreAdminClient() {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY
  if (!key) throw new Error('Store service credentials are not configured.')
  return createClient('https://vzrgjwhkeezojkgxpirn.supabase.co', key, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
}
