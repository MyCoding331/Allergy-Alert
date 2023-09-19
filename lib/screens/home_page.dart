// ignore_for_file: use_build_context_synchronously

import 'package:allergyalert/screens/barcode_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _scanBarcode() async {
    String barcodeResult = "8901512144805";
    // try {
    //   barcodeResult = await FlutterBarcodeScanner.scanBarcode(
    //     '#ff6666', // Custom scanner color
    //     'Cancel', // Cancel button text
    //     true, // Show flash option
    //     ScanMode.DEFAULT, // Scan mode (default, QR, barcode)
    //   );
    // } catch (e) {
    //   barcodeResult = 'Failed to get barcode: $e';
    // }
    if (barcodeResult != '-1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarCodeDetailPage(
            barcode: barcodeResult,
            // allergies: _allergies,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          // color: Colors.lightGreen[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 150,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Scan Barcode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unleash the power of barcode scanning! With just a simple camera scan, discover a world of product insights at your fingertips. Get real-time information, ingredients, nutrition facts, and make informed choices. Say goodbye to uncertainty and embrace a smarter shopping experience. Make every barcode count!',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),
              const Text(
                'About This App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Explore a world of products with ease and convenience. Whether it's groceries or consumer goods, this app offers detailed information to help you make informed choices. Discover product ingredients, nutritional facts, and more, right at your fingertips. Say goodbye to uncertainty and hello to smarter shopping. Empower yourself with knowledge and shop with confidence. Elevate your shopping experience with this all-in-one app.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              const Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Product Details & Descriptions: Explore comprehensive information and detailed descriptions about the products you scan.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nutritional Information: Access detailed nutritional facts and make informed dietary choices.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Allergy Warnings & Ingredient Analysis: Stay safe by receiving allergy alerts and analyzing product ingredients.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Barcode History & Favorites: Keep track of your scanned barcodes and easily access your favorite products.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Unlock the Power of Information! Gain valuable insights about products to enhance your shopping experience.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Personalized Recommendations: Receive tailored suggestions based on your preferences and dietary needs.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Unlock the Power of Information!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'With this app, you can delve into the world of product details, access nutritional information, identify potential allergens, and make smarter choices for a healthier lifestyle. Tap into the power of information and discover the story behind every barcode.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 66),
              const Text(
                'Discover the Story Behind Every Barcode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Uncover the fascinating story behind each product as you explore detailed descriptions and discover the brand's values, manufacturing processes, and quality standards. Gain insights into usage instructions, benefits, and unique features that set each item apart. Let the barcode reveal the secrets and make every purchase a well-informed decision.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () {
                  throw Exception('Test error');
                },
                child: Text('Generate Error'),
              ),
              const SizedBox(height: 66),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: _scanBarcode,
        icon: const Icon(
          Icons.qr_code_scanner,
          size: 24,
        ),
        label: const Text(
          'Scan Barcode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
