import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebBrowserProvider extends ChangeNotifier{
  String url = "https://easacc.com/";

  void setUrl(String url){
    this.url =url;
    notifyListeners();
  }
}