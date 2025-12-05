import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/shared_layout.dart';

void main() {
  testWidgets('ProductListFilters calls callbacks when selections change (narrow layout)', (WidgetTester tester) async {
    String? selectedFilter;
    String? selectedSort;

    final widget = MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300, // force narrow layout path
          child: ProductListFilters(
            selectedFilter: 'All products',
            selectedSort: 'Featured',
            filterOptions: const ['All products', 'T-Shirt', 'Hoodie'],
            sortOptions: const ['Featured', 'Price: low  high', 'Price: low  high'],
            onFilterChanged: (s) => selectedFilter = s,
            onSortChanged: (s) => selectedSort = s,
            totalItems: 5,
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Tap the first dropdown (filter) and select 'T-Shirt'
    final dropdowns = find.byType(DropdownButton<String>);
    expect(dropdowns, findsNWidgets(2));

    await tester.tap(dropdowns.first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('T-Shirt').last);
    await tester.pumpAndSettle();
    expect(selectedFilter, equals('T-Shirt'));

    // Tap the second dropdown (sort) and ensure callback runs
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();

    // The sort options we provided are duplicates for simplicity; pick 'Featured' by tapping it
    await tester.tap(find.text('Featured').last);
    await tester.pumpAndSettle();
    expect(selectedSort, equals('Featured'));
  });
}
