import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:easacc_task/services/social_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final urlTextController = TextEditingController();
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<String> _bluDevices = [];
  String _choosenBlu;
  List<String> _wifiDevices = [];
  String _choosenWifi;

  @override
  void initState() {
    super.initState();
    urlTextController.text = WebBrowserProvider().url;
    _startBluScan();
    _startWifiScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: PreferencePage([
        PreferenceTitle('Web-Browser'),
        Padding(
          padding: EdgeInsets.all(10),
          child:
              Consumer<WebBrowserProvider>(builder: (context, browser, child) {
            urlTextController.text = browser.url;
            return TextField(
              controller: urlTextController,
              onSubmitted: (val) {
                browser.setUrl(val);
                browser.webViewController.loadUrl(val);
              },
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter website url',
                  labelText: "Website URL"),
            );
          }),
        ),
        PreferenceTitle('Near Devices'),
        Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.bluetooth_searching,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Scanning for bluetooth devices ..")));
                          _startBluScan();
                        }),
                    Text("Bluetooth devices: "),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        hint: Text("select device"),
                        value: _choosenBlu,
                        items:
                            new List.generate(_bluDevices.length, (int index) {
                          return new DropdownMenuItem(
                              value: _bluDevices[index],
                              child: new Container(
                                child: new Text(
                                  "${_bluDevices[index]}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                        }),
                        onChanged: (dynamic val) {
                          setState(() {
                            _choosenBlu = val;
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.wifi_tethering,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Scanning for wifi devices ..")));
                          _startWifiScan();
                        }),
                    Text("Wifi devices: "),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        hint: Text("select device"),
                        value: _choosenWifi,
                        items:
                            new List.generate(_wifiDevices.length, (int index) {
                          return new DropdownMenuItem(
                              value: _wifiDevices[index],
                              child: new Container(
                                child: new Text(
                                  "[Device #$index], ${_wifiDevices[index]}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                        }),
                        onChanged: (val) {
                          setState(() {
                            print("#############     " + val.toString());
                            _choosenWifi = val;
                          });
                        }),
                    Expanded(child: Container()),
                  ],
                )
              ],
            )),
        PreferenceTitle('User Data'),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Row(
            children: [
              Text("Logged as: "),
              Text(
                SocialAuth().getEmail(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              TextButton(
                  onPressed: () {
                    SocialAuth().logout(context);
                  },
                  child: Text("log out"))
            ],
          ),
        ),
        PreferenceTitle('About'),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("built by"),
              Text(
                "Hani Mohamed Hussein",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.linkedinIn,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _launchURL(
                            "https://www.linkedin.com/in/hani-m-hussein-16153572/");
                      }),
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.githubSquare,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {
                        _launchURL("https://github.com/HaniMohamed");
                      }),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }

  _startBluScan() {
    int index = 0;
    setState(() {
      _bluDevices = [];
      _choosenBlu = null;
    });
    flutterBlue.scanResults.listen((results) {
      _bluDevices = [];

      for (ScanResult r in results) {
        setState(() {
          print(r.device.name + r.device.type.toString());
          _bluDevices.add(
              r.device.name.isNotEmpty ? r.device.name : "[Device #$index]");
        });
        index++;
      }
    });
    flutterBlue.startScan(timeout: Duration(seconds: 4));
  }

  _startWifiScan() async {
    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final int port = 80;
    setState(() {
      _wifiDevices = [];
      _choosenWifi = null;
    });

    final stream = NetworkAnalyzer.discover(subnet, port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        setState(() {
          _wifiDevices.add(addr.ip);
          // print('Found device: ${addr.ip}');
        });
      }
    });
  }

  Widget urlTextField() {
    return Consumer<WebBrowserProvider>(builder: (context, browser, child) {
      return;
    });
  }

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urlTextController.dispose();
    super.dispose();
  }
}
