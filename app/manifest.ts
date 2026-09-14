import type { MetadataRoute } from 'next'

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'Folus Emporium Stores',
    short_name: 'Folus Emporium Stores',
    description: 'Quality foods, pantry essentials, and thoughtfully curated products from Folus Emporium Stores.',
    icons: [
      { src: '/icon.png', sizes: 'any', type: 'image/png', purpose: 'any' },
      { src: '/icon.png', sizes: 'any', type: 'image/png', purpose: 'maskable' },
    ],
  }
}
