import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:easacc_task/services/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preferences/preferences.dart';
import 'package:preferences/text_field_preference.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final urlTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlTextController.text = WebBrowserProvider().url;
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
