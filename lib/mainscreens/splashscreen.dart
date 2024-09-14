import 'dart:async';

import 'package:codesleuth/authscreens/loginscreen.dart';
import 'package:codesleuth/mainscreens/homescreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  String animationAsset = "assets/animations/splashscreenanim.json";
  String email = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(kDebugMode){
        final screenSize = MediaQuery.of(context).size;
        print('Screen Width ${screenSize.width}');
        print('Screen Height: ${screenSize.height}'); 
      }
    });
    getStatus().whenComplete(() async{

      Timer(const Duration(seconds: 5), ()=> Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>(
          email == "" ? const loginScreen() : const homeScreen()
        ))
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 3.0,
              child: Lottie.asset(animationAsset, width: 100, height: 200),
            ),
            Text(
              "CodeSleuth",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              "Track Your Logical Progress",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getStatus() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userEmail = sharedPreferences.getString("email");

    if(userEmail != null){
      setState(() {
        email = userEmail;
      });
    }
  }
}