import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/finance_rules.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   /* Timer(
      Duration(seconds: 5),
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => FinanceRules()),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: 'images/splashScreenimages.jpeg',
      nextScreen: FinanceRules(),
      splashTransition: SplashTransition.rotationTransition,
      duration: 5000,
      backgroundColor: Colors.green.shade100,
      splashIconSize: 200,
    );

    /*Scaffold(
      body:
      SafeArea(
        child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/splashscreenimage.jpeg',
                    ),
                    fit: BoxFit.fill,
                  )),
            )),
      ),
    );*/
  }
}
