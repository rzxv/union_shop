import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final String title;
  final String color;
  final String size;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.title,
    required this.color,
    required this.size,
    required this.quantity,
    this.price = 0.0,
  });
}

class Order {
  final String id; // simple id (timestamp)
  final DateTime placedAt;
  final List<OrderItem> items;

  Order({required this.id, required this.placedAt, required this.items});

  int get totalItems => items.fold(0, (p, e) => p + e.quantity);
  double get totalPrice => items.fold(0.0, (p, e) => p + e.quantity * e.price);
}

class Orders extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void add(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}

final Orders globalOrders = Orders();
