import type { Metadata } from 'next'
import { Analytics } from '@vercel/analytics/next'
import './globals.css'
import './storefront-enhancements.css'
import './help/help.css'
import './shared-footer.css'
import './clickable-links.css'
import { CartProvider } from '@/components/cart-provider'
import { WishlistProvider } from '@/components/wishlist-provider'
import FloatingWhatsApp from '@/components/floating-whatsapp'
import GoogleAnalytics from '@/components/google-analytics'
import StorefrontFooter from '@/components/storefront-footer'
import AdminFormLoading from '@/components/admin-form-loading'

const site=process.env.NEXT_PUBLIC_SITE_URL || 'https://folus-emporium-stores-online.vercel.app'
const seoTitle="Folus Emporium Stores | Curating Excellence for Life’s Finest Moments"
const seoDescription='Shop kitchen and home appliances, gifts, food and beverages, personal care, beauty, fashion and accessories at Folus Emporium Stores.'

export const metadata:Metadata={
  metadataBase:new URL(site),
  title:{default:seoTitle,template:'%s | Folus Emporium Stores'},
  description:seoDescription,
  keywords:['Folus Emporium Stores','kitchen appliances','souvenirs and gifts','food and beverages','personal care','beauty','fashion','home appliances'],
  alternates:{canonical:'/'},
  openGraph:{type:'website',url:site,siteName:'Folus Emporium Stores',title:seoTitle,description:seoDescription,images:['/folus-emporium-circular-logo.png']},
  twitter:{card:'summary_large_image',title:seoTitle,description:seoDescription,images:['/folus-emporium-circular-logo.png']},
  robots:{index:true,follow:true},
  icons:{icon:[{url:'/icon.png',type:'image/png'}],shortcut:[{url:'/icon.png',type:'image/png'}],apple:[{url:'/apple-icon.png',type:'image/png'}]}
}

export default function RootLayout({children}:Readonly<{children:React.ReactNode}>){return <html lang="en-NG"><body><CartProvider><WishlistProvider>{children}<StorefrontFooter/><FloatingWhatsApp/><AdminFormLoading/></WishlistProvider></CartProvider><GoogleAnalytics/><Analytics/></body></html>}
