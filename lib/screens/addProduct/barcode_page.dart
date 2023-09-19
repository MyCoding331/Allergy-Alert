import 'package:flutter/material.dart';

class BarcodePage extends StatelessWidget {
  final TextEditingController barcodeController;
  final String barcode;

  const BarcodePage({
    Key? key,
    required this.barcodeController,
    required this.barcode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barcode',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            enabled: false,
            controller: barcodeController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: barcode,
            ),
          ),
        ),
      ],
    );
  }
}
