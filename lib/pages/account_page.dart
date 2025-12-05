import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/auth.dart';
import 'package:union_shop/models/orders.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: AuthModel.isSignedIn,
                  builder: (context, signedIn, _) {
                    if (!signedIn) {
                      // Not signed in: show the 'please log in' screen (matches attachment)
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Icon(Icons.person_outline, size: 80, color: Colors.grey),
                            const SizedBox(height: 18),
                            const Text('Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 12),
                            Text('Please log in to view your account.', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4d2963),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 6,
                                shadowColor: Colors.black45,
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/signup'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4d2963),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              child: const Text('Create an account'),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    }

                    // Signed in: show account summary and order history.
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, size: 88, color: Colors.black87),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Center(child: Text('Welcome!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800))),
                          const SizedBox(height: 8),
                          const Center(child: Text('Here you can view past orders.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                          const SizedBox(height: 24),

                          // Orders list
                          AnimatedBuilder(
                            animation: globalOrders,
                            builder: (context, _) {
                              final orders = globalOrders.orders.reversed.toList();
                              if (orders.isEmpty) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 28),
                                    Text('You have no orders yet.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                                    const SizedBox(height: 18),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pushNamed(context, '/'),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                                      child: const Text('Continue shopping'),
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: orders.map((order) {
                                  final placed = order.placedAt.toLocal();
                                  final dateStr = '${placed.day.toString().padLeft(2, '0')}/${placed.month.toString().padLeft(2, '0')}/${placed.year}';
                                  final totalPrice = order.totalPrice.toStringAsFixed(2);

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: ExpansionTile(
                                      title: Text('Order ${order.id}'),
                                      subtitle: Text('$dateStr • ${order.totalItems} items • £$totalPrice'),
                                      children: order.items.map((it) {
                                        final itemPrice = (it.price * it.quantity).toStringAsFixed(2);
                                        return ListTile(
                                          title: Text(it.title),
                                          subtitle: Text('${it.color} • ${it.size}'),
                                          trailing: Text('x${it.quantity}  £$itemPrice'),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
