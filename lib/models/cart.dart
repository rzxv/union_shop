import 'package:flutter/foundation.dart';

class CartItem {
  final String id; // product id
  final String title;
  final String color;
  final String size;
  final String? image;
  int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    this.color = '',
    this.size = '',
    this.image,
    this.quantity = 1,
    required this.price,
  });

  // Build a cart key. For media items (CD/Vinyl) color and size are not
  // meaningful — omit them so identical media entries merge by product id.
  String get key {
    final lowerId = id.toLowerCase();
    final lowerTitle = title.toLowerCase();
    final isMedia = lowerId.contains('cd') || lowerId.contains('vinyl') || lowerTitle.contains('cd') || lowerTitle.contains('vinyl');
    if (isMedia) return id;
    return '$id|$color|$size';
  }
}

class Cart extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get totalItems => _items.values.fold(0, (p, e) => p + e.quantity);

  void add(CartItem item) {
    final k = item.key;
    if (_items.containsKey(k)) {
      _items[k]!.quantity += item.quantity;
    } else {
      _items[k] = CartItem(
        id: item.id,
        title: item.title,
        color: item.color,
        size: item.size,
        image: item.image,
        quantity: item.quantity,
        price: item.price,
      );
    }
    notifyListeners();
  }

  void remove(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void updateQuantity(String key, int quantity) {
    if (_items.containsKey(key)) {
      if (quantity <= 0) {
        _items.remove(key);
      } else {
        _items[key]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Simple global cart instance for the demo/tests. In a larger app prefer
/// providing via InheritedNotifier/Provider and avoid globals.
final Cart globalCart = Cart();
