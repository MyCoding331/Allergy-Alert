import 'package:flutter/material.dart';

class BrandPage extends StatelessWidget {
  final TextEditingController brandController;
  final String brand;
  final bool isBrand;
  final Function() onToggle;
  final ValueChanged<String> onChanged;

  const BrandPage({
    Key? key,
    required this.brandController,
    required this.brand,
    required this.isBrand,
    required this.onToggle,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Brand',
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
          child: Stack(
            children: [
              TextField(
                enabled: brand == ''
                    ? true
                    : isBrand
                        ? false
                        : true,
                controller: brandController,
                style: const TextStyle(fontSize: 16),
                onChanged: onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: isBrand ? brand : 'Enter brand',
                ),
              ),
              if (brand != '')
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: isBrand
                        ? const Icon(Icons.edit)
                        : const Icon(Icons.close),
                    onPressed: onToggle,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
