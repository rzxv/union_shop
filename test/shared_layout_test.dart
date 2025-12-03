import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('header behaviours', () {
    testWidgets('Popup: tapping Shop opens popup and navigates to Collections', (WidgetTester tester) async {
      final app = MaterialApp(
        routes: {
          '/collections': (ctx) => const Scaffold(body: Center(child: Text('Collections Page'))),
        },
        home: Scaffold(
          body: Center(
            child: Builder(builder: (context) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'collections') {
                    Navigator.of(context).pushNamed('/collections');
                  }
                },
                itemBuilder: (ctx) => const [
                  PopupMenuItem(value: 'clothing', child: Text('Clothing')),
                  PopupMenuItem(value: 'collections', child: Text('Collections')),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Shop'),
                ),
              );
            }),
          ),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Shop'), findsOneWidget);

      // Open popup
      await tester.tap(find.text('Shop'));
      await tester.pumpAndSettle();

      // Menu items visible
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);

      // Tap collections -> navigates
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      expect(find.text('Collections Page'), findsOneWidget);
    });

    testWidgets('BottomSheet flow: burger -> Shop -> Collections navigates', (WidgetTester tester) async {
      final app = MaterialApp(
        routes: {
          '/collections': (ctx) => const Scaffold(body: Center(child: Text('Collections Page'))),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: Center(
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Shop'),
                              onTap: () {
                                Navigator.pop(ctx);
                                // Open the shop sheet using the outer context so Navigator is available
                                Future.microtask(() {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (ctx2) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              title: const Text('Collections'),
                                              onTap: () {
                                                Navigator.pop(ctx2);
                                                Navigator.of(context).pushNamed('/collections');
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Open burger
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Shop tile present
      expect(find.widgetWithText(ListTile, 'Shop'), findsOneWidget);

      // Tap Shop to open shop sheet
      await tester.tap(find.widgetWithText(ListTile, 'Shop'));
      await tester.pumpAndSettle();

      // Collections visible
      expect(find.text('Collections'), findsOneWidget);

      // Tap Collections -> navigates
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      expect(find.text('Collections Page'), findsOneWidget);
    });
  });
}