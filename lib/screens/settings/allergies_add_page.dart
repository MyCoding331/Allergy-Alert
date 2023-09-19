import 'package:appwrite/appwrite.dart';
import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class AllergiesPage extends StatefulWidget {
  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  final TextEditingController _allergiesController = TextEditingController();
  List<String> _allergies = [];
  String databaseId = '64ac1c588e458119e0d6';
  String collectionId = '64ac1d03f3702603c555';
  String documentId = '';
  String id = '';
  late RealtimeSubscription subscribtion;
  List<String> suggetAllegies = [
    "Milk",
    "Eggs",
    "Fish",
    "Shellfish",
    "Tree nuts (such as almonds, walnuts, cashews)",
    "Peanuts",
    "Wheat",
    "Soybeans",
    "Sesame seeds",
    "Mustard",
    "Celery",
    "Gluten",
    "Lupin",
    "Sulphites",
    "Mollusks (such as clams, mussels, oysters)",
    "Cabbage",
    "Carrots",
    "Onions",
    "Garlic",
    "Peas",
    "Lentils",
    "Chickpeas",
    "Sunflower seeds",
    "Flaxseeds",
    "Pecans",
    "Hazelnuts",
    "Brazil nuts",
    "Pistachios",
    "Macadamia nuts",
    "Pine nuts",
    "Kiwi fruit",
    "Mangoes",
    "Avocado",
    "Strawberries",
    "Raspberries",
    "Blueberries",
    "Blackberries",
    "Cranberries",
    "Tomatoes",
    "Potatoes",
    "Bell peppers",
    "Corn",
    "Rice",
    "Oats",
    "Barley",
    "Rye",
    "Saffron",
    "Cumin",
    "Ginger",
    "Cinnamon",
  ];

  @override
  void initState() {
    super.initState();
    _getAllergies();
    subscribe();
// Closes the subscription.
    // subscribtion.close();
    // createDocument();
  }

  // Future<void> _getAllergies() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _allergies = prefs.getStringList('allergies') ?? [];
  //   });
  // }

  Future<void> _getAllergies() async {
    try {
      final user = await account.get();
      final email = user.email;
      final response = await databases.listDocuments(
        databaseId: databaseId, // Replace with your Appwrite database ID
        collectionId: collectionId,

        queries: [
          Query.equal('email', email),
        ], // Replace with your Appwrite collection ID
      );

      final documents = response.documents;

      final allergies = documents
          .map((document) =>
              (document.data['allergies'] as List<dynamic>).cast<String>())
          .expand((list) => list)
          .toList();

      setState(() {
        _allergies = allergies;
      });
    } catch (error) {
      print('Error fetching allergies: $error');
      // Handle any errors that occurred during the process
    }
  }

  Future<void> createDocument() async {
    try {
      final user = await account.get();
      String email = user.email;
      String name = user.name;
      final response = await databases.createDocument(
        collectionId: collectionId,
        data: {
          'email': email,
          'name': name,
        },
        databaseId: databaseId,
        documentId: uniqueId,
      );

      documentId = response.data['\$id'];
      print('Document created with ID: $documentId');
      print('Document ID is : $documentId');
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  Future<void> _addAllergy(String allergy) async {
    try {
      final user = await account.get();
      final email = user.email;
      final name = user.name;

      _allergies.add(allergy);
      _allergies = _allergies.toSet().toList();

      // Replace with the document ID you want to update

      // Update the allergies attribute in the Appwrite document
      final allergies = [
        ..._allergies
      ]; // Create a copy of the updated allergies list
      final response = await databases.listDocuments(
        databaseId: databaseId, // Replace with your Appwrite database ID
        collectionId: collectionId,

        queries: [
          Query.equal('email', email),
        ], // Replace with your Appwrite collection ID
      );

      if (response.documents.isEmpty) {
        // Create a new document
        final createDoc = await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: uniqueId,
          data: {
            "email": email,
            "name": name,
            "allergies": allergies,
          },
        );

        documentId = createDoc.data['\$id'];

        print('Document created with ID: $documentId');
      } else {
        final documentId = response.documents[0].$id;
        // Update an existing document
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: {
            "email": email,
            "name": name,
            "allergies": allergies,
          },
        );
      }
      print('Document  with ID: $documentId updated allergies with $allergies');
      _allergiesController.clear();
    } catch (error) {
      print('Error adding allergy: $error');
      // Handle any errors that occurred during the process
    }
  }

  Future<void> _addManually() async {
    String allergy = _allergiesController.text.trim();
    if (allergy.isNotEmpty && !_allergies.contains(allergy)) {
      await _addAllergy(allergy)
          .then((value) => {_showSnackBar('allergy added successfully')});
    }
  }

  Future<void> _removeAllergy(String allergy) async {
    // setState(() {
    //   _allergies.remove(allergy);
    //   _saveAllergies();
    // });
    final allergies = [..._allergies];
    allergies.remove(allergy);
    final removedAllergies = allergies;
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
      final documentId = response.documents[0].$id;
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: {
          "email": email,
          "name": name,
          "allergies": removedAllergies,
        },
      );

      print('allergie is removed: $allergies');
    } catch (error) {
      print("Error removing allergies $error");
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
          .contains('databases.*.collections.*.documents.*.update')) {
        handleDocumentUpdate(payload);
      }
    });
  }

  void handleDocumentCreation(Map<String, dynamic> payload) {
    // final documentId = payload['\$id'] as String;

    setState(() {
      _allergies = List<String>.from(payload['allergies']);
      _getAllergies();
    });

    // Perform additional actions for document creation
  }

  void handleDocumentUpdate(Map<String, dynamic> payload) {
    // final updatedDocumentId = payload['\$id'] as String;

    setState(() {
      _allergies = List<String>.from(payload['allergies']);
      _getAllergies();
    });

    // Perform additional actions for document update
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Allergies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _allergiesController,
                    decoration: InputDecoration(
                      hintText: 'Enter allergy',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(2400.0), // Rounded border
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 16.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return suggetAllegies
                        .where((allergy) => allergy
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _addAllergy(suggestion).then(
                        (value) => _showSnackBar('Allergy added successfully'));
                  },
                  noItemsFoundBuilder: (context) {
                    return const SizedBox.shrink();
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  animationStart: 1.0,
                  animationDuration: const Duration(milliseconds: 300),
                  suggestionsBoxVerticalOffset: 0,
                  hideOnLoading: true,
                ),
                Positioned(
                  right: -6,
                  top: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _addManually();
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), // Rounded button
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.add, size: 28, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const SizedBox(height: 16),
            const Text(
              'Your Allergies:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergies.map((allergy) {
                return Chip(
                    label: Text(
                      allergy,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.9),
                    deleteButtonTooltipMessage: 'Remove Allergy',
                    onDeleted: () => {
                          _removeAllergy(allergy),
                          _showSnackBar('allergy successfully removed')
                        });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _allergiesController.dispose();

    super.dispose();
    subscribtion.close();
  }
}
