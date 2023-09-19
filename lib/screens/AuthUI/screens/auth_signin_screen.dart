import 'dart:core';
import 'dart:math';

import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/screens/AuthUI/screens/auth_login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;
  String email = '';
  String password = '';
  String name = '';
  String collectionId = '64ac1d467e6083b1bb04';
  String databaseId = '64ac1c588e458119e0d6';

  late String randomString;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
    // Define the characters to include in the random string
    const characters =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

    // Generate a random string of length 10
    randomString = String.fromCharCodes(
      List.generate(20,
          (_) => characters.codeUnitAt(Random().nextInt(characters.length))),
    );
    // print(randomString);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

// String userId = randomString;
  Future<void> _signUp() async {
    try {
      final user = await account.create(
        userId: randomString,
        email: email,
        password: password,
        name: name,
      );

      if (kDebugMode) {
        print("User created with ID: ${user.$id}");
      }

      final document = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: uniqueId,
        data: {
          "userId": randomString,
          'email': email,
          'password': password,
          'name': name,
        },
      );

      if (kDebugMode) {
        print('Document created with ID: ${document.$id}');
      }

      // ignore: use_build_context_synchronously
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginScreen(),
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print('Error during sign up: $error');
      }
      // Handle any errors that occurred during sign up
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // AnimatedBuilder(
                  //   animation: _animationController,
                  //   builder: (context, child) {
                  //     return FadeTransition(
                  //       opacity: _fadeInAnimation,
                  //       child: SlideTransition(
                  //         position: _slideUpAnimation,
                  //         child: child,
                  //       ),
                  //     );
                  //   },
                  //   child: Image.asset(
                  //     'assets/images/logo.png',
                  //     width: 100,
                  //     height: 100,
                  //   ),
                  // ),
                  const SizedBox(height: 26),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: _slideUpAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: TextField(
                      onChanged: (value) => {
                        setState(() {
                          name = value;
                        })
                      },
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: _slideUpAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: TextField(
                        onChanged: (value) => {
                              setState(() {
                                email = value;
                              })
                            },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.mail),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                  const SizedBox(height: 26),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: _slideUpAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: TextField(
                      onChanged: (value) => {
                        setState(() {
                          password = value;
                        })
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: _slideUpAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80000.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            _signUp();
                            // Perform registration logic
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      const Text("Are you already a member then",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                      TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    LoginScreen(),
                              ),
                            );
                          },
                          child: const Text("login",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
