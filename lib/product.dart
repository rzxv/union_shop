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
  // Autumn collection products
  'autumn_hoodie_1': Product(
    id: 'autumn_hoodie_1',
    title: 'Autumn Hoodie 1',
    price: 18.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ],
    colors: ['Black', 'Orange'],
    description: 'Autumn collection hoodie. Warm and comfortable for chilly days.',
  ),
  'autumn_tshirt_2': Product(
    id: 'autumn_tshirt_2',
    title: 'Autumn T\u2011Shirt 2',
    price: 12.50,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    ],
    colors: ['White', 'Black'],
    description: 'Lightweight autumn tee with seasonal print.',
  ),
  'autumn_accessory_3': Product(
    id: 'autumn_accessory_3',
    title: 'Autumn Accessory 3',
    price: 6.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
    ],
    description: 'Autumn collection accessory.',
  ),
  'autumn_hoodie_4': Product(
    id: 'autumn_hoodie_4',
    title: 'Autumn Hoodie 4',
    price: 20.00,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    ],
    colors: ['Grey', 'Black'],
    description: 'Cozy hoodie for the autumn season.',
  ),
  'autumn_tshirt_5': Product(
    id: 'autumn_tshirt_5',
    title: 'Autumn T\u2011Shirt 5',
    price: 11.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ],
    description: 'Seasonal tee with comfortable fit.',
  ),
  'autumn_accessory_6': Product(
    id: 'autumn_accessory_6',
    title: 'Autumn Accessory 6',
    price: 7.99,
    images: [
      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ],
    description: 'Small accessory from the autumn range.',
  ),
  'placeholder_1': Product(id: 'placeholder_1', title: 'Placeholder Product 1', price: 10.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_2': Product(id: 'placeholder_2', title: 'Placeholder Product 2', price: 15.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_3': Product(id: 'placeholder_3', title: 'Placeholder Product 3', price: 20.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
  'placeholder_4': Product(id: 'placeholder_4', title: 'Placeholder Product 4', price: 25.0, images: ['https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'], description: 'Placeholder description.'),
};
