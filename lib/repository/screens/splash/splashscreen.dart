import 'dart:async';

import 'package:flutter/material.dart';
import 'package:madeq/domain/constants/appcolors.dart';
import 'package:madeq/repository/screens/auth/LoginScreen.dart';
import 'package:madeq/repository/widgets/uihelper.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomText(text: "Welcome to MedeQ", color: AppColors.brand100, fontweight: FontWeight.w500, fontsize: 30),
          ],
        ),
      ),
    );
  }
}
