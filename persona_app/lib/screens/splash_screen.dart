import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay for 2 seconds before navigating to the OnboardingScreen
    Future.delayed(Duration(seconds: 2), () {
      context.go(RouteConstants.onboardingRoute);
    });

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white, // Ensure the container color is also white
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: Color(0x4d9e9e9e), width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/Frame-2.png"),
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}