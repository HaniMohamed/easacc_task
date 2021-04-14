import 'dart:async';

import 'package:easacc_task/services/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLogined = false;

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      checkSigned();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/easacc-Logo.png", width: 150,),
              )),
          Container(
            height: 200,
            child: Column(mainAxisSize: MainAxisSize.min,
                    children: [
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: () {
                          SocialAuth().signInWithFacebook();
                          checkSigned();
                        },
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: () {
                          SocialAuth().signInWithGoogle();
                          checkSigned();
                        },
                      ),
                    ]
            ),
          )

        ],
      ),
    );
  }

  bool checkSigned() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        return false;
      } else {
        print('User is signed in!');
        Navigator.of(context).pushNamed("/web_browser");
        return true;
      }
    });
    return false;
  }
}
