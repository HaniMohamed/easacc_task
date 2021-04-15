import 'dart:async';

import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowserScreen extends StatefulWidget {
  @override
  _WebBrowserScreenState createState() => _WebBrowserScreenState();
}

class _WebBrowserScreenState extends State<WebBrowserScreen> {
  double lineProgress = 0.0;
  final Completer<WebViewController> webviewController =
      Completer<WebViewController>();
  WebViewController webController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: .5,
        title: Text("Easacc Browser"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: "Refresh web page",
              onPressed: () => refreshWeb()),
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open settings',
            onPressed: () {
              Navigator.of(context).pushNamed("/settings");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          webView(),
          Positioned(
              child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            value: lineProgress,
          )),
        ],
      ),
    );
  }

  Consumer<WebBrowserProvider> webView() {
    return Consumer<WebBrowserProvider>(
      builder: (context, browser, child) {
        return WebView(
          initialUrl: browser.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webviewController.complete(webViewController);
            browser.registerWebview(webViewController);
            webController = webViewController;
          },
          onProgress: (int progress) {
            setState(() {
              lineProgress = progress / 100;
            });
            print("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      },
    );
  }

  refreshWeb() {
    webController.reload();
  }
}
