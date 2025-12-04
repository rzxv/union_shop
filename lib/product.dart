class Product {
  final String id;
  final String title;
  final double price;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.images = const [],
    this.colors = const ['Black'],
    this.sizes = const ['S', 'M', 'L'],
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
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ],
    colors: ['Black', 'Grey', 'Purple'],
    description: 'A cosy zip hoodie in limited edition colours. Our limited edition zip hoodie is made from a soft cotton blend, featuring a full zip and branded embroidery. Perfect for layering.',
  ),
  'essential_tshirt': Product(
    id: 'essential_tshirt',
    title: 'Essential T-Shirt',
    price: 6.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    ],
    colors: ['Black', 'White'],
    description: 'Lightweight essential tee. A staple tee made from breathable cotton. Available in multiple colours and easy to wash.',
  ),
  'signature_hoodie': Product(
    id: 'signature_hoodie',
    title: 'Signature Hoodie',
    price: 29.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    ],
    description: 'Premium signature hoodie. Our signature hoodie features a heavier weight fabric and embroidered logo for lasting quality.',
  ),
  'signature_cap': Product(
    id: 'signature_cap',
    title: 'Signature Cap',
    price: 9.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ],
    description: 'Classic cap with logo. A classic structured cap with embroidered badge, adjustable strap, and breathable eyelets.',
  ),
  'placeholder_1': Product(id: 'placeholder_1', title: 'Placeholder Product 1', price: 10.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_2': Product(id: 'placeholder_2', title: 'Placeholder Product 2', price: 15.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_3': Product(id: 'placeholder_3', title: 'Placeholder Product 3', price: 20.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_4': Product(id: 'placeholder_4', title: 'Placeholder Product 4', price: 25.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
};
