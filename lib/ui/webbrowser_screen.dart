import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowserScreen extends StatefulWidget {
  @override
  _WebBrowserScreenState createState() => _WebBrowserScreenState();
}

class _WebBrowserScreenState extends State<WebBrowserScreen> {
  double lineProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eassac Browser"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open settings',
            onPressed: () {
              Navigator.of(context).pushNamed("/settings");
            },
          ),
        ],
      ),
      body: Consumer<WebBrowserProvider>(
        builder: (context, browser, child) {
          return WebView(
            initialUrl: browser.url,
          );
        },
      ),
    );
  }
}
