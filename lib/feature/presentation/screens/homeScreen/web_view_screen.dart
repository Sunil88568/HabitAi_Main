import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? controller;

  @override
  void initState() {
    openWebView();
    super.initState();
  }

  void openWebView() {
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("Page started loading: $url");
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
          },
          onNavigationRequest: (NavigationRequest request) {

            print("Page finished loading: ${request.url}");
            if (request.url.contains("success")) {
              Navigator.pop(context, "success");
              return NavigationDecision.prevent;
            }else if(request.url.contains("cancel")){
              Navigator.pop(context, "fail");
              return NavigationDecision.navigate;
            }else{
              return NavigationDecision.navigate;
            }


          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url)); // Load dynamic URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller!,
        ),
      ),
    );
  }
}
