import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preferences/text_field_preference.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: PreferencePage([
        PreferenceTitle('Web-Browser'),
        TextFieldPreference(
          'Website Url',
          'website_url',
          onChange: onUrlChanged,
        ),
        PreferenceTitle('About'),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("This app build by"),
              Text("Hani Mohamed Hussein", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.linkedinIn,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _launchURL("https://www.linkedin.com/in/hani-m-hussein-16153572/");
                      }),
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.githubSquare,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {_launchURL("https://github.com/HaniMohamed");}),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }

  void onUrlChanged(val){
    print("$val");
    WebBrowserProvider().setUrl(val);
  }

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
