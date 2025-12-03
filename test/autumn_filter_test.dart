import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/autumn_collection.dart';

void main() {
  testWidgets('Autumn filter dropdown updates product count', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: AutumnCollection(header: SizedBox.shrink(), footer: SizedBox.shrink())));
    await tester.pumpAndSettle();

    // Initially all products should be shown (9 products)
    expect(find.text('9 products'), findsOneWidget);
    expect(find.text('All products'), findsOneWidget);

    // Open the filter dropdown and select "T-Shirt"
    await tester.tap(find.text('All products'));
    await tester.pumpAndSettle();

    // The dropdown menu items are rendered in an overlay; select the last matching "T-Shirt" text.
    await tester.tap(find.text('T-Shirt').last);
    await tester.pumpAndSettle();

    // After selecting T-Shirt, only the 3 T-Shirt items should remain
    expect(find.text('3 products'), findsOneWidget);
    expect(find.text('9 products'), findsNothing);
  });
}
