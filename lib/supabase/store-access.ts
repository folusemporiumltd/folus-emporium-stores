import 'server-only'
import { createClient } from '@/lib/supabase/server'
import { createStoreAdminClient } from '@/lib/supabase/admin'
import { redirect } from 'next/navigation'

/** Main project authenticates people; all commerce records live in Stores. */
export async function getStoreCustomer() {
  const identity = await createClient()
  const { data: { user } } = await identity.auth.getUser()
  if (!user?.email) return null
  const db = createStoreAdminClient()
  return { user, db }
}

export async function ensureStoreCustomer(db: ReturnType<typeof createStoreAdminClient>, user: {id:string;email?:string|null;user_metadata?:Record<string,unknown>}) {
  if (!user.email) throw new Error('An email address is required.')
  const { error } = await db.from('store_customers').upsert({
    id:user.id,
    email:user.email,
    full_name:typeof user.user_metadata?.full_name === 'string' ? user.user_metadata.full_name : null,
    updated_at:new Date().toISOString(),
  },{onConflict:'id'})
  if (error) throw new Error('Store customer record could not be saved.')
}

export async function requireStoreAdmin(next: string) {
  const identity = await createClient()
  const { data: { user } } = await identity.auth.getUser()
  if (!user) redirect(`/login?next=${encodeURIComponent(next)}&mode=signin`)
  const { data: allowed, error } = await identity.rpc('get_my_admin_status')
  if (error || allowed !== true) redirect('/account?admin_error=access')
  return { db: createStoreAdminClient(), user }
}
