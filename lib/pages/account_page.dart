import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/auth.dart';

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

                    // Signed in: show a simple account summary with sign out option.
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          const Icon(Icons.person, size: 88, color: Colors.black87),
                          const SizedBox(height: 18),
                          const Text('Welcome!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          const Text('Here you can view past orders and manage your details.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              AuthModel.signOut();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                            child: const Text('Sign out'),
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
