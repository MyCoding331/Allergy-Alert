import 'package:flutter/material.dart';

class ProductNamePage extends StatelessWidget {
  final TextEditingController productNameController;
  final String productName;
  final bool isProductName;
  final Function() onToggle;
  final ValueChanged<String> onChanged;

  const ProductNamePage({
    Key? key,
    required this.productNameController,
    required this.productName,
    required this.isProductName,
    required this.onToggle,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Name",
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
                enabled: productName == ''
                    ? true
                    : isProductName
                        ? false
                        : true,
                controller: productNameController,
                style: const TextStyle(fontSize: 16),
                onChanged: onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: isProductName ? productName : 'Enter product name',
                ),
              ),
              if (productName != '')
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: isProductName
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
