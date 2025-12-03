import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/collections_page.dart';

/// Minimal HttpOverrides that returns a 1x1 transparent PNG for any network image.
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _FakeHttpClientRequest();
  }

  @override
  void close({bool force = false}) {}
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientResponse> close() async {
    return _FakeHttpClientResponse();
  }

  // Match the non-nullable API on IOSink
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

  testWidgets('CollectionsPage shows grid and tapping a card navigates to /product', (WidgetTester tester) async {
    // Force a desktop-sized viewport (so any remaining layout won't overflow).
    const testSize = Size(1200, 800);

    final app = MaterialApp(
      routes: {
        '/product': (ctx) => const Scaffold(body: Center(child: Text('Product Page'))),
      },
      // Inject empty header/footer to avoid building AppHeader/AppFooter in the test.
      home: Scaffold(
        body: Center(
          child: MediaQuery(
            data: MediaQueryData(size: testSize),
            child: SizedBox(
              width: testSize.width,
              height: testSize.height,
              child: const CollectionsPage(
                header: SizedBox.shrink(),
                footer: SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Page title
    expect(find.text('Collections'), findsOneWidget);

    // Check a few collection titles from the dummy data
    expect(find.text('Autumn Favourites'), findsOneWidget);
    expect(find.text('Clothing'), findsOneWidget);
    expect(find.text('Graduation'), findsOneWidget);

    // Tap the first collection title to trigger navigation
    await tester.tap(find.text('Autumn Favourites'));
    await tester.pumpAndSettle();

    // Should have navigated to /product
    expect(find.text('Product Page'), findsOneWidget);
  });
}