// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:allergyalert/screens/barcode_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _barcodeResult = 'Scan a barcode';

  @override
  void initState() {
    super.initState();

    // _scanBarcode();
  }

  Future<void> _scanBarcode() async {
    String barcodeResult = '';
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
    setState(() {
      _barcodeResult = barcodeResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Barcode Scanner'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _barcodeResult,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanBarcode,
              child: const Text('Scan Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
