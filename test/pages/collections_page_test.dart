import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/collections_page.dart';

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

  testWidgets('Tapping a non-Autumn collection navigates to /product', (WidgetTester tester) async {
    const testSize = Size(1200, 800);
    // Force test window size so responsive layouts render the desktop layout.
    tester.view.physicalSize = testSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final app = MaterialApp(
      routes: {
        '/product': (ctx) => const Scaffold(body: Center(child: Text('Product Page'))),
      },
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

  // Ensure a non-Autumn collection title exists. The collections data
  // was updated; test for 'Merchandise' which maps to the default
  // '/product' navigation in the current UI.
  expect(find.text('Merchandise'), findsOneWidget);

  // Tap the 'Merchandise' collection which should route to '/product'
  await tester.tap(find.text('Merchandise'));
    await tester.pumpAndSettle();

    expect(find.text('Product Page'), findsOneWidget);
  });
}