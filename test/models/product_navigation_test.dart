import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/product_page.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();
  @override
  void close({bool force = false}) {}
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
  @override
  Encoding encoding = utf8;
}

class _FakeHttpClientResponse implements HttpClientResponse {
  static final _pngBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII='
  );

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _pngBytes.length;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final controller = StreamController<List<int>>();
    controller.add(_pngBytes);
    controller.close();
    return controller.stream.listen(onData ?? (_) {});
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Home -> Product navigation shows product title and price', (WidgetTester tester) async {
    // Build a minimal app that contains a ProductCard and routes to ProductPage
  final mediaSize = Size(1200, 1600);
    tester.view.physicalSize = mediaSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final app = MaterialApp(
      routes: {
        '/product': (ctx) {
          final id = ModalRoute.of(ctx)!.settings.arguments as String?;
          final prod = id != null && productRegistry.containsKey(id) ? productRegistry[id] : null;
          return ProductPage(product: prod, header: const SizedBox.shrink(), footer: const SizedBox.shrink());
        }
      },
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 220, child: ProductCard(productId: 'essential_tshirt')),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(ProductCard), findsOneWidget);

    await tester.tap(find.byType(ProductCard));
    await tester.pumpAndSettle();

    // Look up the registry values
    final p = productRegistry['essential_tshirt']!;
    expect(find.text(p.title), findsOneWidget);
    expect(find.text('£${p.price.toStringAsFixed(2)}'), findsOneWidget);
  });
}
