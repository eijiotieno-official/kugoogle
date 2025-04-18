import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/url_util.dart';
import '../views/loading_view.dart';
import '../views/navigator_view.dart';
import '../views/search_input_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController? _webViewController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  int _progress = 0;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    final encodedUrl = UrlUtil.encodeUrl(value);
    _initializeWebView(encodedUrl);
  }

  void _initializeWebView(String url) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: _onProgress,
              onPageFinished: _onPageFinished,
              onNavigationRequest: (request) => NavigationDecision.navigate,
            ),
          )
          ..loadRequest(Uri.parse(url));

    setState(() {
      _webViewController = controller;
    });
  }

  void _onProgress(int progress) {
    setState(() {
      _progress = progress;
    });
  }

  void _onPageFinished(String url) {
    _searchController.text = url;
  }

  Future<void> _onBack() async {
    if (_webViewController == null) return;

    final canGoBack = await _webViewController!.canGoBack();
    if (canGoBack) {
      await _webViewController!.goBack();
    } else {
      setState(() {
        _searchController.clear();
        _webViewController = null;
      });
    }
  }

  Future<void> _onForward() async {
    if (_webViewController == null) return;

    final canGoForward = await _webViewController!.canGoForward();
    if (canGoForward) {
      await _webViewController!.goForward();
    }
  }

  void _onClear() {
    setState(() {
      _searchController.clear();
    });
  }

  Future<void> _handlePop(bool didPop, dynamic result) async {
    if (!didPop) {
      await _onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePop,
      child: Material(
        child: SafeArea(
          child: Column(
            spacing: 2.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SearchInputView(
                searchController: _searchController,
                focusNode: _searchFocusNode,
                onSearch: _onSearch,
                onClear: _onClear,
                onChanged: (_) => setState(() {}),
              ),
              LoadingView(progress: _progress),
              if (_webViewController != null) ...[
                Expanded(child: WebViewWidget(controller: _webViewController!)),
                NavigatorView(onBack: _onBack, onForward: _onForward),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
