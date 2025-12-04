import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart'; // HeroCarousel & ProductCard and ProductPage

/// Fake HttpOverrides to return a 1x1 PNG for any network request.
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

  testWidgets('main.dart: HeroCarousel advances and ProductCard navigates', (WidgetTester tester) async {
    // Make the test window large enough so widgets fit and taps hit.
    const physicalSize = Size(1200, 1600);
    const devicePixelRatio = 1.0;

    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = devicePixelRatio;

    // Ensure we clean up the test window override.
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Use a MediaQuery sized to the useful area (carousel height 400 + product card)
    final mediaQuerySize = Size(1200, 1400);

    final app = MaterialApp(
      routes: {
        '/product': (ctx) => const Scaffold(body: Center(child: Text('Product Page'))),
      },
      home: Scaffold(
        body: Center(
          child: MediaQuery(
            data: MediaQueryData(size: mediaQuerySize),
            child: SizedBox(
              width: mediaQuerySize.width,
              // Compose only the widgets we want from main.dart:
              // the HeroCarousel and a single ProductCard (keeps everything in view).
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 400, // HeroCarousel uses 400 height
                    child: HeroCarousel(),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Featured', textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 8),
                  // Place a ProductCard in view (no need to scroll)
                  SizedBox(
                    height: 200,
                    child: const ProductCard(
                      productId: 'test_product',
                      title: 'Test Product',
                      price: '£9.99',
                      imageUrl: 'https://example.invalid/image.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  // Short pump to stabilize layout without waiting for repeating timers.
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 100));

    // 1) Carousel initial slide
    expect(find.byType(HeroCarousel), findsOneWidget);
    expect(find.text("What's your next move..."), findsOneWidget);

    // 2) Advance carousel using right chevron
    final rightChevron = find.byIcon(Icons.chevron_right);
    expect(rightChevron, findsOneWidget);
    await tester.tap(rightChevron);
    // Let the PageView animation run (HeroCarousel uses a 500ms animation for page changes).
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Make university life easier'), findsOneWidget);

    // 3) Pause -> play toggle
    final pauseFinder = find.byIcon(Icons.pause);
    expect(pauseFinder, findsOneWidget);
    await tester.tap(pauseFinder);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);

    // 4) Tap ProductCard to navigate to /product
    final productCard = find.byType(ProductCard);
    expect(productCard, findsOneWidget);

    await tester.tap(productCard);
    await tester.pumpAndSettle();

  expect(find.text('Product Page'), findsOneWidget);
  
  }, timeout: const Timeout(Duration(seconds: 30)));
}