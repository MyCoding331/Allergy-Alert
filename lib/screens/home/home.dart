// ignore_for_file: use_build_context_synchronously

import 'package:allergyalert/screens/barcode_detail_page.dart';
import 'package:allergyalert/screens/settings/history_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _scanBarcode() async {
    String barcodeResult = "";
    try {
      barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Custom scanner color
        'Cancel', // Cancel button text
        true, // Show flash option
        ScanMode.DEFAULT, // Scan mode (default, QR, barcode)
      );
    } catch (e) {
      barcodeResult = 'Failed to get barcode: $e';
    }
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
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  final Widget svg = SvgPicture.asset('assets/images/logo/svg',
      semanticsLabel: 'AllergyAlert Logo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            child: Center(
              child:

                  //         Lottie.asset(
                  //   'assets/images/barcode.json',
                  //   width: 220,
                  //   height: 220,
                  //   fit: BoxFit.fill,
                  // ),
                  Hero(
                tag: 'logo', // Add a unique tag for the Hero animation
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: 'AllergyAlert Logo',
                  width: 200,
                  height: 100,
                ),
              ),
            ),
          ),
          // const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarCodeDetailPage(barcode: value),
                  ),
                );
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Code',
                prefixIcon: const Icon(
                  Icons.code,
                  color: Colors.grey,
                ),
                suffixIcon: _textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _textEditingController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
              child: Text(
            'or',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _scanBarcode();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8000),
                ),
              ),
              child: const Text('Scan Barcode'),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recent Scans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: HistoryPage(),
          ),
        ],
      ),
    );
  }
}
