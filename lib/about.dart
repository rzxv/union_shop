import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF4d2963),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  // Hero image
                  SizedBox(
                    height: 220,
                    child: Image.network(
                      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'About Union Shop',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Union Shop is the student store for our university — providing clothing, merchandise and essential items for campus life. '
                    'This demo app reproduces the main shop landing experience and includes product previews, a print-personalisation section and store info.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.4),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What we do',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[900]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '- Provide essential campus clothing and merchandise.\n'
                    '- Offer a personalisation service for clothing.\n'
                    '- Run seasonal sales and promotions for students.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Contact & Opening Hours',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[900]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: store@example.edu\nPhone: 01234 567890\nMonday - Friday: 10:00 - 16:00\nPurchase online 24/7',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Back to Store', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}