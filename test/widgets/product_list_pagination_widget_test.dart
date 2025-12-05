import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/utils/products_pagination.dart';

void main() {
  testWidgets('ProductListPagination shows correct range and buttons enable/disable', (WidgetTester tester) async {
    int? calledWith;

    final widget = MaterialApp(
      home: Scaffold(
        body: ProductListPagination(
          page: 0,
          pageSize: 2,
          totalItems: 5,
          onPageChanged: (p) => calledWith = p,
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Text should show 'Showing 1 - 2 of 5'
    expect(find.textContaining('Showing 1 - 2 of 5'), findsOneWidget);

    // Previous button should be disabled (onPressed == null)
    final prevFinder = find.widgetWithText(OutlinedButton, 'Previous');
    expect(prevFinder, findsOneWidget);
    final OutlinedButton prevButton = tester.widget(prevFinder);
    // reflect disabled by onPressed == null
    expect(prevButton.onPressed, isNull);

    // Next button should be enabled; tap it and verify callback
    final nextFinder = find.widgetWithText(OutlinedButton, 'Next');
    expect(nextFinder, findsOneWidget);
    final OutlinedButton nextButton = tester.widget(nextFinder);
    expect(nextButton.onPressed, isNotNull);

    await tester.tap(nextFinder);
    await tester.pumpAndSettle();
    expect(calledWith, equals(1));
  });
}
