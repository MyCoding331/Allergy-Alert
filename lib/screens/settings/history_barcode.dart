import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/screens/barcode_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> barcodes = [];
  List<DocumentData> favorites = [];
  List<Document> data = [];
  List<Map<String, dynamic>> items = [];
  Map<String, Product> productMap = {};
  String name = '';
  String image = '';
  String barcode = '';
  String productName = '';
  String brand = '';
  String databaseId = '64ac1c588e458119e0d6';
  String collectionId = '64ac1c801cd0beff880f';
  late RealtimeSubscription subscribtion;
  Future<bool>? _fetchHistory;

  @override
  void initState() {
    super.initState();
    // _getBarcodes();
    _fetchHistory = _getBarcodes();
    subscribe();
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        // action: SnackBarAction(
        //   label: 'Undo',
        //   textColor: Colors.white,
        //   onPressed: () {
        //     // Implement your undo logic here
        //   },
        // ),
      ),
    );
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
            'name': product.productName ?? '',
            'brand': product.brands ?? '',
            'image': product.imageFrontUrl ?? '',
          };
          barcodeData.add(productData);
        }
      }

      final barcodeDataJson = jsonEncode(barcodeData);
      await prefs.setString('barcodes', barcodeDataJson);

      if (kDebugMode) {
        print('Saved barcodes: $barcodes');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error saving barcodes: $error');
      }
    }
  }

  Future<bool> _getBarcodes() async {
    try {
      final user = await account.get();
      final email = user.email;
      final name = user.name;

      final response = await databases.listDocuments(
        databaseId: databaseId, // Replace with your Appwrite database ID
        collectionId: collectionId,

        queries: [
          Query.equal('email', email),
        ], // Replace with your Appwrite collection ID
      );
      setState(() {
        data = response.documents;

        favorites = response.documents.map((document) {
          var data = document.data;
          return DocumentData(
            email:
                data['email'] ?? '', // Assign a default value if email is null
            name: data['name'] ?? '', // Assign a default value if name is null
            image: data['image'] ?? '',
            barcode: data['barcode'] ?? '',
            productName: data['productName'] ?? '',
            brand: data['brand'] ?? '',
            // Assign a default value if imageUrl is null
          );
        }).toList();
      });
      print('history is fetched: ${response.documents}');
      return true;
    } catch (error) {
      print("Error fetching history $error");
      return false;
    }
  }

  Future<void> _removeBarcode(String documentId) async {
    // setState(() async {
    //   barcodes.remove(barcode);
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.remove(barcode);
    //   saveBarcodes();
    // });
    try {
      await databases
          .deleteDocument(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          )
          .then(
            (_) => {
              print("document successfully deleted with id $documentId"),
            },
          )
          .then(
            (value) => {
              _showSnackBar('document successfully deleted'),
            },
          );

      // setState(() {
      //   data.removeWhere((item) => item.$id == documentId);
      // });

      // print('Failed to delete document');
    } catch (error) {
      print('Error deleting document: $error');
      _showSnackBar('Error deleting document: $error');
    }
  }

  void subscribe() {
    subscribtion = realtime.subscribe(['documents']);
    subscribtion.stream.listen((event) {
      final eventType = event.events;
      final payload = event.payload;

      if (eventType.contains('databases.*.collections.*.documents.*.create')) {
        handleDocumentCreation(payload);
      } else if (eventType
          .contains('databases.*.collections.*.documents.*.delete')) {
        handleDocumentUpdate(payload);
      }
    });
  }

  void handleDocumentCreation(Map<String, dynamic> payload) {
    // final documentId = payload['\$id'] as String;
    final document = DocumentData.fromMap(payload);
    favorites.add(document);
    setState(() {
      _getBarcodes();
    });

    // Perform additional actions for document creation
  }

  void handleDocumentUpdate(Map<String, dynamic> payload) {
    // final updatedDocumentId = payload['\$id'] as String;

    final deletedBarcode = DocumentData.fromMap(payload);
    favorites
        .removeWhere((document) => document.barcode == deletedBarcode.barcode);
    setState(() {
      _getBarcodes();
    });
    // Perform additional actions for document update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<void>(
              future: _fetchHistory, // Remove the parentheses here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading history'),
                  );
                } else {
                  return _buildHistoryList();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'No history found',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final history = favorites[index];
            final documentId = data[index].$id;

            return GestureDetector(
              onTap: () {
                // Navigate to the other page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarCodeDetailPage(
                      barcode: history.barcode,
                    ),
                  ),
                );
              },
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                // secondaryBackground: Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   decoration: BoxDecoration(
                //     color: Colors.grey,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   alignment: Alignment.centerRight,
                //   child: const Icon(
                //     Icons.cancel,
                //     color: Colors.white,
                //   ),
                // ),
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this item?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    return confirm ?? false;
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _removeBarcode(documentId);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.lightBlueAccent,
                      margin: const EdgeInsets.all(4),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    history.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder_image.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.info,
                                              color: Colors.blue,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              history.productName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.branding_watermark,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        history.brand,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Barcode: ${history.barcode}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    subscribtion.close();
    super.dispose();
  }
}

class DocumentData {
  final String email;
  final String name;
  final String image;
  final String barcode;
  final String productName;
  final String brand;

  DocumentData({
    required this.email,
    required this.name,
    required this.image,
    required this.barcode,
    required this.productName,
    required this.brand,
  });

  factory DocumentData.fromMap(Map<String, dynamic> json) {
    return DocumentData(
      email: json['email'],
      name: json['name'],
      image: json['image'],
      barcode: json['barcode'],
      productName: json['productName'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nmail': email,
      'name': name,
      'image': image,
      'barcode': barcode,
      'productName': productName,
      'brand': brand,
    };
  }
}
