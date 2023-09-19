import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/model/bottom_navgation_bar.dart';
import 'package:allergyalert/model/loader.dart';
import 'package:allergyalert/screens/AuthUI/screens/auth.dart';
import 'package:allergyalert/screens/AuthUI/screens/auth_signin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthCheckerScreen extends StatefulWidget {
  const AuthCheckerScreen({super.key});

  @override
  State<AuthCheckerScreen> createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
  Future<bool>? _userSessionFuture;

  @override
  void initState() {
    super.initState();
    _userSessionFuture = checkUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _userSessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking the user session
            return Center(
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
                  const SizedBox(height: 8),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              // Handle any errors that occurred while checking the user session
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'An error occurred. Please try again later.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error Details:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // User session exists, navigate to the home screen
              if (snapshot.data == true) {
                if (kDebugMode) {
                  print(snapshot.data);
                }
                return const MyBottomNavigationBar();
              }
              // User session does not exist, navigate to the login screen
              else {
                if (kDebugMode) {
                  print(snapshot.data);
                }
                return const AuthPage();
              }
            }
          }
        },
      ),
    );
  }

  Future<bool> checkUserSession() async {
    try {
      // Check if the user session exists
      await account.get();
      return true;
    } catch (e) {
      // Handle any errors that occurred while checking the user session
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }
}
