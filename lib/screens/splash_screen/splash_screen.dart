import 'package:allergyalert/screens/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Call the navigateToSecondScreen function after five seconds
    Future.delayed(const Duration(seconds: 5), navigateToSecondScreen);
  }

  // Function to navigate to the second screen
  void navigateToSecondScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthCheckerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo', // Add a unique tag for the Hero animation
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                semanticsLabel: 'AllergyAlert Logo',
                width: 200,
                height: 100,
              ),
            ),
            Text(
              'Allergy Detection App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
