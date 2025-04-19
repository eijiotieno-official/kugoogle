// Importing necessary Flutter and WebView packages
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Importing utility and custom view components
import '../utils/url_util.dart';
import '../views/loading_view.dart';
import '../views/navigator_view.dart';
import '../views/search_input_view.dart';

// Entry point widget for the home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// The state class for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // Controller to interact with the WebView
  WebViewController? _webViewController;

  // Controller for the search text input
  final TextEditingController _searchController = TextEditingController();

  // Focus node to manage keyboard focus on the search input
  final FocusNode _searchFocusNode = FocusNode();

  // Integer value representing the loading progress of the WebView (0 to 100)
  int _progress = 0;

  @override
  void dispose() {
    // Clean up the controllers and focus nodes when the widget is disposed
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Called when the user performs a search
  void _onSearch(String value) {
    // Encodes the search query into a proper URL
    final encodedUrl = UrlUtil.encodeUrl(value);
    // Initializes the WebView with the given URL
    _initializeWebView(encodedUrl);
  }

  // Initializes the WebView controller with settings and loads the given URL
  void _initializeWebView(String url) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JS support
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: _onProgress, // Called to update loading progress
              onPageFinished:
                  _onPageFinished, // Called when page finishes loading
              onNavigationRequest:
                  (request) =>
                      NavigationDecision.navigate, // Allow all navigation
            ),
          )
          ..loadRequest(Uri.parse(url)); // Load the requested URL

    // Update the state with the new controller
    setState(() {
      _webViewController = controller;
    });
  }

  // Callback to update loading progress
  void _onProgress(int progress) {
    setState(() {
      _progress = progress;
    });
  }

  // Callback when the page finishes loading
  void _onPageFinished(String url) {
    // Update the search input field with the loaded URL
    _searchController.text = url;
  }

  // Handles back navigation in the WebView
  Future<void> _onBack() async {
    if (_webViewController == null) return;

    // Check if WebView can go back in history
    final canGoBack = await _webViewController!.canGoBack();
    if (canGoBack) {
      // Navigate back
      await _webViewController!.goBack();
    } else {
      // Clear the WebView and search input if no history
      setState(() {
        _searchController.clear();
        _webViewController = null;
      });
    }
  }

  // Handles forward navigation in the WebView
  Future<void> _onForward() async {
    if (_webViewController == null) return;

    // Check if WebView can go forward in history
    final canGoForward = await _webViewController!.canGoForward();
    if (canGoForward) {
      // Navigate forward
      await _webViewController!.goForward();
    }
  }

  // Clears the search input field
  void _onClear() {
    setState(() {
      _searchController.clear();
    });
  }

  // Handles the system back button behavior
  Future<void> _handlePop(bool didPop, dynamic result) async {
    // If back pop was not already handled, try navigating back
    if (!didPop) {
      await _onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent system back button by default
      onPopInvokedWithResult: _handlePop, // Custom back handling
      child: Material(
        child: SafeArea(
          child: Column(
            spacing: 2.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom search input widget
              SearchInputView(
                searchController: _searchController,
                focusNode: _searchFocusNode,
                onSearch: _onSearch,
                onClear: _onClear,
                onChanged: (_) => setState(() {}), // Rebuild on text change
              ),
              // Custom loading bar view showing the progress
              LoadingView(progress: _progress),

              // Show WebView and navigation buttons only when initialized
              if (_webViewController != null) ...[
                // Display the web page content
                Expanded(child: WebViewWidget(controller: _webViewController!)),

                // Navigation controls for back and forward
                NavigatorView(onBack: _onBack, onForward: _onForward),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
