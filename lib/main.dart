import 'package:allergyalert/screens/AuthUI/screens/auth.dart';
import 'package:allergyalert/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   // Call your custom error handling function or display error screen here
  //   handleGlobalError(details);
  // };
  OpenFoodAPIConfiguration.userAgent = const UserAgent(
    name: 'allergyalert',
  );

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH
  ];

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.USA;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allergy Alert',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        fontFamily: 'poppins',
      ),
      debugShowCheckedModeBanner: false,
      home:
          //  const AuthPage(),
          const SplashScreen(),
      // AddProductScreen(barcode: 'kadfoihfoh'),
    );
  }
}
