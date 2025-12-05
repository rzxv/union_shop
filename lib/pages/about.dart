import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/pages/theprintshack_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _openPersonalisation(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ThePrintShackPage()));
  }

  @override
  Widget build(BuildContext context) {
    final contentPadding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0);

    final paragraphStyle = TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
      height: 1.9,
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),

            // Main centered content area 
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Container(
                  color: Colors.white, 
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      const Center(
                        child: Text(
                          'About us',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      Text(
                        'Welcome to the Union Shop!',
                        style: paragraphStyle.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 18),

                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: paragraphStyle,
                          children: [
                            const TextSpan(
                              text:
                                  'We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive ',
                            ),
                            TextSpan(
                              text: 'personalisation service',
                              style: paragraphStyle.copyWith(
                                decoration: TextDecoration.underline,
                                color: const Color(0xFF1E88E5),
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _openPersonalisation(context);
                                },
                            ),
                            const TextSpan(text: '!'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'All online purchases are available for delivery or instore collection!',
                        style: paragraphStyle,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.',
                        style: paragraphStyle,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'Happy shopping!',
                        style: paragraphStyle,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 22),

                      Text(
                        'The Union Shop & Reception Team',
                        style: paragraphStyle.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
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