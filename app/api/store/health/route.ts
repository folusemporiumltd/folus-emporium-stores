import { NextResponse } from 'next/server'
import { createStoreAdminClient } from '@/lib/supabase/admin'

export const dynamic = 'force-dynamic'

export async function GET() {
  try {
    const { error } = await createStoreAdminClient().from('orders').select('id', { head: true, count: 'exact' })
    return NextResponse.json({ storeDatabase: error ? 'unavailable' : 'connected' }, {
      status: error ? 503 : 200,
      headers: { 'Cache-Control': 'no-store' },
    })
  } catch {
    return NextResponse.json({ storeDatabase: 'unavailable' }, { status: 503, headers: { 'Cache-Control': 'no-store' } })
  }
}
