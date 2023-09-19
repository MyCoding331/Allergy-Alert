// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/model/loader.dart';
import 'package:allergyalert/model/local_storage_product.dart';
import 'package:flutter/services.dart';
// import 'package:allergyalert/screens/addProduct/add_product_page.dart';
import 'package:allergyalert/screens/addProduct/add_product_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarCodeDetailPage extends StatefulWidget {
  final String barcode;

  BarCodeDetailPage({
    Key? key,
    required this.barcode,
  }) : super(key: key);

  @override
  _BarCodeDetailPageState createState() => _BarCodeDetailPageState();
}

class _BarCodeDetailPageState extends State<BarCodeDetailPage> {
  Map<String, dynamic> _productDetails = {};
  List<String> filteredIngredients = [];
  List<String> allergies = [];
  List<String> barcodes = [];
  String status = '';
  Product? product;
  Map<String, Product> productMap = {};
  final TextEditingController _barcodesController = TextEditingController();
  String databaseId = '64ac1c588e458119e0d6';
  String collectionId = '64ac1c801cd0beff880f';
  String documentId = '';
  @override
  void initState() {
    super.initState();
    _getAllergies();
    // fetchProductDetails();

    getProduct();
    // _addBarcodes(widget.barcode);
  }

  Future<void> createDocument(
      String barcode, String productName, String brand, String image) async {
    try {
      final user = await account.get();
      String email = user.email;
      String name = user.name;

      final list = await databases.listDocuments(
        databaseId: databaseId, // Replace with your Appwrite database ID
        collectionId: collectionId,

        queries: [
          Query.equal('email', email),
          Query.equal('barcode', barcode),
          Query.equal('productName', productName),
        ], // Replace with your Appwrite collection ID
      );
      if (list.documents.isEmpty) {
        final response = await databases.createDocument(
          collectionId: collectionId,
          data: {
            'email': email,
            'name': name,
            "barcode": barcode,
            "productName": productName,
            "brand": brand,
            "image": image,
          },
          databaseId: databaseId,
          documentId: uniqueId,
        );

        documentId = response.data['\$id'];
        print('Document created with ID: $documentId');
        print('Document ID is : $documentId');
      } else {
        print('Document already exists.');
      }
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  Future<void> _getAllergies() async {
    try {
      final user = await account.get();
      final email = user.email;
      final response = await databases.listDocuments(
        databaseId:
            '64ac1c588e458119e0d6', // Replace with your Appwrite database ID
        collectionId: '64ac1d03f3702603c555',

        queries: [
          Query.equal('email', email),
        ], // Replace with your Appwrite collection ID
      );

      final documents = response.documents;

      final allergiesList = documents
          .map((document) =>
              (document.data['allergies'] as List<dynamic>).cast<String>())
          .expand((list) => list)
          .toList();

      setState(() {
        allergies = allergiesList;
      });
    } catch (error) {
      print('Error fetching allergies: $error');
      // Handle any errors that occurred during the process
    }
  }

  Future<void> saveBarcodes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, String>> barcodeData = [];

      for (final barcode in barcodes) {
        final product = productMap[barcode];
        if (product != null) {
          final productData = {
            'barcode': barcode,
            'name': product.productName ?? 'Unknown',
            'brand': product.brands ?? 'Unknown',
            'image': product.imageFrontUrl ?? '',
          };
          barcodeData.add(productData);
        } else {
          // Add placeholder data for missing product
          final productData = {
            'barcode': barcode,
            'name': 'Unknown',
            'brand': 'Unknown',
            'image': '',
          };
          barcodeData.add(productData);
        }
      }

      final barcodeDataJson = jsonEncode(barcodeData);
      await prefs.setString('barcodes', barcodeDataJson);

      if (kDebugMode) {
        print('Saved data: $barcodeDataJson');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error saving barcodes: $error');
      }
    }
  }

  // Future<void> _addBarcodes(
  //     String barcode, String name, String brand, String image) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final productData = {
  //     'barcode': barcode,
  //     'name': name,
  //     'brand': brand,
  //     'image': image,
  //   };
  //   final productJson = jsonEncode(productData);
  //   await prefs.setString(barcode, productJson);

  //   // print('added data: $productJson');
  //   setState(() {
  //     barcodes.add(productJson);
  //     saveBarcodes();
  //     if (kDebugMode) {
  //       print('added data: $barcodes');
  //     }
  //     _barcodesController.clear(); // Clear the text field before saving
  //   });
  // }

  Future<void> _addBarcodes(
      String barcode, String name, String brand, String image) async {
    await createDocument(barcode, name, brand, image);
  }

  Future<Product?> getProduct() async {
    var barcode = widget.barcode;

    // Check if the product is available in local storage
    // final cachedProduct = await LocalStorage.getProduct(barcode);
    // print('Cached product: $cachedProduct');

    // if (cachedProduct != null) {
    //   setState(() {
    //     product = cachedProduct.product;
    //     status = cachedProduct.result!.id!;
    //     filterIngredients();

    //     // Add any additional desired logic for handling the cached product
    //   });
    //   return product;
    // }

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);
    if (kDebugMode) {
      print(result.status);
    }
    setState(() {
      status = result.result!.id!;
      // filterIngredients();
    });

    if (status == 'product_found') {
      setState(() {
        product = result.product!;
        filterIngredients();

        _addBarcodes(barcode, product!.productName!, product!.brands!,
            product!.imageFrontUrl!);

        // Save the product details in local storage
        // final productJson = jsonEncode(result.toJson());
        // LocalStorage.saveProduct(result, productJson);
        // print('Saved to local storage $productJson');
      });
      return result.product;
    } else {
      throw Exception('Product not found for barcode: $barcode');
    }
  }

  void filterIngredients() {
    List<String> ingredients = product?.ingredients
            ?.map((ingredient) => ingredient.text ?? '')
            .toList() ??
        [];

    List<String> lowerCaseAllergies =
        allergies.map((allergy) => allergy.toLowerCase()).toList();

    filteredIngredients = ingredients.where((ingredient) {
      for (String allergy in lowerCaseAllergies) {
        RegExp pattern = RegExp(allergy, caseSensitive: false);
        if (pattern.hasMatch(ingredient.toLowerCase())) {
          return true;
        }
      }
      return false;
    }).toList();

    print('Allergies: $allergies');
    print('Ingredients: $ingredients');
    print('Filtered Ingredients: $filteredIngredients');

    if (allergies.isNotEmpty) {
      if (filteredIngredients.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => Theme(
            data: ThemeData(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            child: AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Allergy Alert',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: filteredIngredients
                    .map((ingredient) => ListTile(
                          leading: const Icon(
                            Icons.dangerous,
                            color: Colors.red,
                          ),
                          title: Text(
                            ingredient,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => Theme(
            data: ThemeData(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            child: AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'No Allergies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'There is no allergies in this product',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: ThemeData(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: AlertDialog(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  'No Allergies Added',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Add allergies in settings to see it available',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

// categories_tag
  @override
  Widget build(BuildContext context) {
    // print(status);
    String productName = product?.productName ?? '';
    String brand = product?.brands ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product No: ${widget.barcode}',
          style: const TextStyle(color: Colors.blue),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          // _productDetails.isNotEmpty
          status == 'product_found'
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name: ${product?.productName ?? ''}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                product?.imageFrontUrl ?? '',
                                fit: BoxFit.cover,
                                height: 250,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/placeholder_image.png', // Replace with your asset image path
                                    fit: BoxFit.cover,
                                    height: 250,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                product?.imageNutritionUrl ?? '',
                                fit: BoxFit.cover,
                                height: 250,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/placeholder_image.png', // Replace with your asset image path
                                    fit: BoxFit.cover,
                                    height: 250,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (product!.ingredients != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product?.ingredients?.map((ingredient) {
                                final isAllergy = filteredIngredients
                                    .contains(ingredient.text);

                                return GestureDetector(
                                  onTap: () {
                                    isAllergy
                                        ? showDialog(
                                            context: context,
                                            builder: (context) => Theme(
                                              data: ThemeData(
                                                dialogTheme: DialogTheme(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                              ),
                                              child: AlertDialog(
                                                title: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Allergy Alert',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: filteredIngredients
                                                      .map((ingredient) =>
                                                          ListTile(
                                                            leading: const Icon(
                                                              Icons.dangerous,
                                                              color: Colors.red,
                                                            ),
                                                            title: Text(
                                                              ingredient,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isAllergy)
                                        const Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      Chip(
                                        label: Text(
                                          ingredient.text ?? '',
                                          style: TextStyle(
                                            color: isAllergy
                                                ? Colors.red.shade50
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: isAllergy
                                            ? Colors.red
                                            : Colors.green.shade500,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList() ??
                              [],
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'there is no ingredient you want to ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddProductScreen(
                                        barcode: widget.barcode,
                                        productName: productName.isNotEmpty
                                            ? productName
                                            : '',
                                        brand: brand.isNotEmpty ? brand : '',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Brand: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '${product?.brands}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nutrition Facts:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Colors.indigo,
                                //   width: 2.0,
                                // ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(2),
                                },
                                border: TableBorder.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: product?.nutriments
                                        ?.toJson()
                                        .entries
                                        .map((entry) {
                                      String key = entry.key;
                                      dynamic value = entry.value;
                                      return TableRow(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 3),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue[100],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8000)),
                                            child: Text(
                                              '$key:',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue[200],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8000)),
                                            child: Text(
                                              value?.toString() ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList() ??
                                    [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : status == 'product_not_found'
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Product Not Found',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddProductScreen(
                                    barcode: widget.barcode,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Add Product',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Loader(),
                    ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(
                barcode: widget.barcode,
                productName: productName.isNotEmpty ? productName : '',
                brand: brand.isNotEmpty ? brand : '',
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.update),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _barcodesController.dispose();

    super.dispose();
  }
}
