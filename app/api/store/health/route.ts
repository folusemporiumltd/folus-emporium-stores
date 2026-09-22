import { NextResponse } from 'next/server'
import { createStoreAdminClient } from '@/lib/supabase/admin'

export const dynamic = 'force-dynamic'

export async function GET() {
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
    return NextResponse.json({ storeDatabase: 'unavailable', reason: 'missing_store_credential' }, { status: 503, headers: { 'Cache-Control': 'no-store' } })
  }
  try {
    const { error } = await createStoreAdminClient().from('orders').select('id', { head: true, count: 'exact' })
    return NextResponse.json({ storeDatabase: error ? 'unavailable' : 'connected', ...(error ? { reason: 'invalid_store_credential_or_connection' } : {}) }, {
      status: error ? 503 : 200,
      headers: { 'Cache-Control': 'no-store' },
    })
  } catch {
    return NextResponse.json({ storeDatabase: 'unavailable' }, { status: 503, headers: { 'Cache-Control': 'no-store' } })
  }
}
