import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowserProvider extends ChangeNotifier {
  String url = "https://easacc.com/";
  WebViewController webViewController;

  void setUrl(String urlString) {
    url = urlString;
    notifyListeners();
  }

  void registerWebview(WebViewController wvc) {
    webViewController = wvc;
  }
}
