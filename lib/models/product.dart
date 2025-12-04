class Product {
  final String id;
  final String title;
  final double price;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final double? salePrice;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.images = const [],
    this.colors = const ['Black'],
    this.sizes = const ['S', 'M', 'L'],
    this.salePrice,
    this.description = '',
  });
}

/// A small registry of products used on the main page. Add more entries here
/// when you create new product pages.
const Map<String, Product> productRegistry = {
  'limited_essential_zip_hoodie': Product(
    id: 'limited_essential_zip_hoodie',
    title: 'Limited Edition Essential Zip Hoodies',
    price: 14.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888384/navyhoodie_vvh6hu.png',
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888389/purplehoodie_zqubs4.png',
    ],
    colors: ['Navy', 'Purple'],
    description: 'A cosy zip hoodie in limited edition colours. Our limited edition zip hoodie is made from a soft cotton blend, featuring a full zip and branded embroidery. Perfect for layering.',
  ),
  'essential_tshirt': Product(
    id: 'essential_tshirt',
    title: 'Essential T-Shirts',
    price: 6.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888121/whitet_lxjfyx.png',
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888637/purpleshirt_muy8o0.png',
    ],
    colors: ['White', 'Purple'],
    description: 'Lightweight essential tee. A staple tee made from breathable cotton. Available in multiple colours and easy to wash.',
  ),
  'signature_mug': Product(
    id: 'signature_mug',
    title: 'Signature Mug',
    price: 6.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888920/sigcup_hfx1ow.jpg',
    ],
    colors: ['White'],
    description: 'Ceramic signature mug with printed logo — microwave and dishwasher safe. Perfect for coffee or tea on campus.',
  ),
  'signature_cap': Product(
    id: 'signature_cap',
    title: 'Signature Cap',
    price: 9.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764888924/sigcap_ljqxlh.jpg',
    ],
    description: 'Classic cap with logo. A classic structured cap with embroidered badge, adjustable strap, and breathable eyelets.',
  ),
  // Autumn collection products
  'autumn_hoodie_1': Product(
    id: 'autumn_hoodie_1',
    title: 'Russet Zip Hoodie',
    price: 18.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875053/russet_zip_hoodie_mhze14.png',
    ],
    colors: ['Russet'],
    description: 'A cosy zip-up hoodie in warm russet tones — soft brushed fleece and a relaxed fit for cool autumn days.',
  ),
  'autumn_tshirt_2': Product(
    id: 'autumn_tshirt_2',
    title: 'Leaf Print T\u2011Shirt',
    price: 12.50,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875054/leaf_print_tshirt_oyqv7k.png',
    ],
    colors: ['Ivory'],
    description: 'Soft cotton tee featuring a subtle leaf-motif print — lightweight and breathable for layering.',
  ),
  'autumn_accessory_3': Product(
    id: 'autumn_accessory_3',
    title: 'Wool Knit Beanie',
    price: 6.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875049/wool_knit_beanie_uqoqif.png',
    ],
    colors: ['Mustard'],
    description: 'A snug ribbed beanie made from soft wool-blend yarn — a perfect autumn accessory to keep you warm.',
  ),
  'autumn_hoodie_4': Product(
    id: 'autumn_hoodie_4',
    title: 'Forest Fleece Hoodie',
    price: 20.00,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875058/forest_fleece_hoodie_qyt0le.png',
    ],
    colors: ['Forest'],
    description: 'Mid-weight fleece hoodie with brushed interior — cosy, durable and ready for crisp walks in the park.',
  ),
  'autumn_tshirt_5': Product(
    id: 'autumn_tshirt_5',
    title: 'Harvest Logo Tee',
    price: 11.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875047/harvest_logo_tee_zikmeo.png',
    ],
    colors: ['Brick'],
    description: 'Classic crew tee with a small harvest logo — soft, durable cotton for everyday wear.',
  ),
  'autumn_accessory_6': Product(
    id: 'autumn_accessory_6',
    title: 'Autumn Scarf',
    price: 7.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764875053/autumn_scarf_bgq4ah.png',
    ],
    colors: ['Burnt Orange'],
    description: 'Lightweight woven scarf with autumnal colours — an easy way to add warmth and texture to an outfit.',
  ),
  // Sale collection - 6 curated physical releases (CD & Vinyl)
  // NUJABES
  'nujabes_cd': Product(
    id: 'nujabes_cd',
    title: 'Nujabes — Luv(sic) (CD)',
    price: 19.99,
    salePrice: 12.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764881901/nujabes_cd_riq9rg.jpg',
    ],
    colors: ['Black'],
    description: 'Classic Nujabes release on CD — lush instrumentals and soulful samples, remastered for clear listening.',
  ),
  'nujabes_vinyl': Product(
    id: 'nujabes_vinyl',
    title: 'Nujabes — Metaphorical Music (Vinyl)',
    price: 34.99,
    salePrice: 22.74,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764881919/nujabes_vinyl_xmhn2n.webp',
    ],
    colors: ['Black'],
    description: 'Limited vinyl pressing of Nujabes — warm analogue mastering, perfect for collectors and vinyl lovers.',
  ),

  // MASS OF THE FERMENTING DREGS
  'motfd_cd': Product(
    id: 'motfd_cd',
    title: 'Mass of the Fermenting Dregs - World is yours (CD)',
    price: 18.99,
    salePrice: 12.34,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764881769/motfd_cd_rkep9j.avif',
    ],
    colors: ['Black'],
    description: 'Live Sessions on CD — an energetic capture of the band’s raw live performances and fan favourites.',
  ),
  'motfd_vinyl': Product(
    id: 'motfd_vinyl',
    title: 'Mass of the Fermenting Dregs — Kirametal (Vinyl)',
    price: 29.99,
    salePrice: 19.49,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764881772/motfd_vinyl_yslxsj.webp',
    ],
    colors: ['Black'],
    description: 'Live Sessions double-LP — gatefold vinyl with live photos and liner notes.',
  ),

  // RADIOHEAD
  'radiohead_cd': Product(
    id: 'radiohead_cd',
    title: 'Radiohead — In rainbows (CD)',
    price: 19.99,
    salePrice: 12.99,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764882065/radiohead_cd_gagyat.webp',
    ],
    colors: ['Black'],
    description: 'Remastered CD edition of In rainbows — essential listening with expanded liner notes.',
  ),
  'radiohead_vinyl': Product(
    id: 'radiohead_vinyl',
    title: 'Radiohead — OK Computer (Vinyl)',
    price: 34.99,
    salePrice: 22.74,
    images: [
      'https://res.cloudinary.com/dl650ouuv/image/upload/v1764882069/radiohead_vinyl_wo2j2n.webp',
    ],
    colors: ['Black'],
    description: 'Gatefold vinyl pressing of OK Computer — heavyweight vinyl with restored artwork and inner sleeve.',
  ),
  'placeholder_1': Product(id: 'placeholder_1', title: 'Placeholder Product 1', price: 10.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_2': Product(id: 'placeholder_2', title: 'Placeholder Product 2', price: 15.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_3': Product(id: 'placeholder_3', title: 'Placeholder Product 3', price: 20.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_4': Product(id: 'placeholder_4', title: 'Placeholder Product 4', price: 25.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
};
