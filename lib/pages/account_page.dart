import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/auth.dart';
import 'package:union_shop/models/orders.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstController;
  late TextEditingController _lastController;

  @override
  void initState() {
    super.initState();
    final user = AuthModel.currentUser.value;
    _firstController = TextEditingController(text: user?.firstName ?? '');
    _lastController = TextEditingController(text: user?.lastName ?? '');
    AuthModel.currentUser.addListener(_syncFromModel);
  }

  void _syncFromModel() {
    final user = AuthModel.currentUser.value;
    _firstController.text = user?.firstName ?? '';
    _lastController.text = user?.lastName ?? '';
    setState(() {});
  }

  @override
  void dispose() {
    AuthModel.currentUser.removeListener(_syncFromModel);
    _firstController.dispose();
    _lastController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    AuthModel.updateProfile(firstName: _firstController.text.trim().isEmpty ? null : _firstController.text.trim(), lastName: _lastController.text.trim().isEmpty ? null : _lastController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  void _doSignOut() {
    AuthModel.signOut();
  }

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

                    // Signed in: show account summary, editable name fields, sign out and order history.
                    final user = AuthModel.currentUser.value;
                    final email = user?.email ?? '';
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
                          Center(child: Text('Welcome${user?.firstName != null ? ', ${user!.firstName}' : ''}!', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800))),
                          const SizedBox(height: 8),
                          Center(child: Text(email, style: const TextStyle(color: Colors.black87))),
                          const SizedBox(height: 12),

                          // Profile edit form
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text('Your details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _firstController,
                                      decoration: const InputDecoration(labelText: 'First name'),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _lastController,
                                      decoration: const InputDecoration(labelText: 'Last name'),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: _saveProfile,
                                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                                          child: const Text('Save'),
                                        ),
                                        const SizedBox(width: 12),
                                        TextButton(
                                          onPressed: _doSignOut,
                                          style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                          child: const Text('Sign out'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Text('Order history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),

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
