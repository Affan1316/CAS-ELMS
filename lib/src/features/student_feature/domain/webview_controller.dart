import 'package:webview_flutter/webview_flutter.dart';

import '../domain/webview_page_type.dart';

class WebViewControllerVM {
  late final WebViewController controller;

  WebViewControllerVM() {
    controller =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  /// Load page based on enum type
  Future<void> loadPage(WebViewPageType type) async {
    await controller.loadRequest(Uri.parse(type.url));
  }

  /// Dispose controller
  void dispose() {
    controller.clearCache();
    // Normally WebViewController has no dispose(), so we clean resources manually.
  }
}
