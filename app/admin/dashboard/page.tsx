import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient, createCatalogueClient } from '@/lib/supabase/server'
import { createStoreAdminClient } from '@/lib/supabase/admin'

export const dynamic = 'force-dynamic'

export default async function StoreDashboard({ searchParams }: { searchParams: Promise<{ error?: string }> }) {
  const params = await searchParams
  const identity = await createClient()
  const { data: { user } } = await identity.auth.getUser()
  if (!user) redirect('/login?next=/admin/dashboard&mode=signin')
  const { data: isAdmin, error } = await identity.rpc('get_my_admin_status')
  if (error || isAdmin !== true) redirect('/account?admin_error=access')

  // Read counts only from the separate Stores project. The shared project
  // supplies the user identity and admin permission, never store data.
  const store = await createCatalogueClient()
  const [products, categories] = await Promise.all([
    store.from('products').select('id', { count: 'exact', head: true }),
    store.from('categories').select('id', { count: 'exact', head: true }),
  ])
  let orderCount: number | null = null
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) {
    const { count, error: ordersError } = await createStoreAdminClient().from('orders').select('id', { count: 'exact', head: true })
    if (!ordersError) orderCount = count
  }

  return <main>
    <div className="topbar"><div className="container"><span>Folus Emporium Stores</span><span>Store administration</span></div></div>
    <header className="nav"><div className="container nav-inner"><Link className="brand" href="/"><img src="/folus-emporium-circular-logo.png" alt="Folus Emporium Stores"/><span>FOLUS<br/>EMPORIUM STORES<small>Admin Dashboard</small></span></Link><nav className="navlinks"><Link href="/admin/dashboard">Dashboard</Link><Link href="/admin/products">Store products</Link><Link href="/shop">View store</Link><Link href="/account">Account</Link></nav></div></header>
    <section className="section"><div className="container" style={{maxWidth:1050}}>
      <div className="eyebrow">Store administration</div><h1>Folus Emporium Stores dashboard</h1>
      <p className="muted">Signed in as {user.email}. Your login is shared with Folus Emporium; this dashboard uses the separate Stores catalogue.</p>
      {params.error === 'store_configuration' && <p role="alert">The Store product manager cannot connect to its database. Configure the Stores project's SUPABASE_SERVICE_ROLE_KEY in Vercel.</p>}
      <div className="admin-dashboard-stats" style={{marginTop:28}}>
        <article className="admin-dashboard-stat"><span>Store products</span><strong>{products.error?'—':products.count??0}</strong><p>In the Stores database</p></article>
        <article className="admin-dashboard-stat"><span>Store categories</span><strong>{categories.error?'—':categories.count??0}</strong><p>In the Stores database</p></article>
        <article className="admin-dashboard-stat"><span>Store orders</span><strong>{orderCount??'—'}</strong><p>In the Stores database</p></article>
      </div>
      {(products.error||categories.error)&&<p role="alert">Store catalogue totals are temporarily unavailable.</p>}
      {orderCount === null && <p role="alert">Store administration cannot connect to private Store records. Check that SUPABASE_SERVICE_ROLE_KEY in this Vercel project belongs to the Folus Emporium Stores Supabase project.</p>}
      <section className="admin-dashboard-panel" style={{marginTop:28}}><h2>Manage this store</h2><p className="muted">Manage Folus Emporium Stores records separately from the main website.</p><div style={{display:'flex',gap:12,flexWrap:'wrap'}}><Link className="btn btn-primary" href="/admin/products">Store products</Link><Link className="btn btn-outline" href="/admin/orders">Store orders</Link><Link className="btn btn-outline" href="/admin/inventory">Inventory</Link><Link className="btn btn-outline" href="/admin/coupons">Store coupons</Link><Link className="btn btn-outline" href="/admin/reviews">Store reviews</Link><Link className="btn btn-outline" href="/admin/reports">Reports</Link><Link className="btn btn-outline" href="/admin/storefront">Storefront</Link><Link className="btn btn-outline" href="/admin/company">Store content</Link></div></section>
    </div></section>
  </main>
}
