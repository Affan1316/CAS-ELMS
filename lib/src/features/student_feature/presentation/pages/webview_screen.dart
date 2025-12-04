import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/webview_page_type.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/webview_controller.dart';

class WebViewScreen extends StatefulWidget {
  final WebViewPageType pageType;

  const WebViewScreen({super.key, required this.pageType});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewControllerVM viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = WebViewControllerVM();
    viewModel.loadPage(widget.pageType);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pageType.title)),
      body: WebViewWidget(controller: viewModel.controller),
    );
  }
}
