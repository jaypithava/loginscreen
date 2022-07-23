import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loginscreen/LoginScreen.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/images/background.jpg',fit: BoxFit.fill,),
      ),
    );
  }
}