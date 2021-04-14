import 'package:easacc_task/provider/web_browser_provider.dart';
import 'package:easacc_task/ui/login_screen.dart';
import 'package:easacc_task/ui/settings_screen.dart';
import 'package:easacc_task/ui/webbrowser_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      ChangeNotifierProvider(
      create: (context) => WebBrowserProvider(),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
    builder: (context, snapshot) {
    // Check for errors
    if (snapshot.hasError) {
    return CircularProgressIndicator();
    }

    // Once complete, show your application
    if (snapshot.connectionState == ConnectionState.done) {
    return  buildMaterialApp();
    }

    // Otherwise, show something whilst waiting for initialization to complete
    return CircularProgressIndicator();
    },
    );


  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
    title: 'Easacc Task',
    theme: ThemeData(
      primarySwatch: Colors.blue,

      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: LoginScreen(),
    routes: {
      "/login":(context) => LoginScreen(),
      "/settings":(context) => SettingsScreen(),
      "/web_browser":(context) => WebBrowserScreen(),


    },
  );
  }
}
