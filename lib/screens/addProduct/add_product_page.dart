// ignore_for_file: use_build_context_synchronously, must_be_immutable, library_private_types_in_public_api

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class AddProductScreen extends StatefulWidget {
  String barcode;
  String productName;
  String brand;

  AddProductScreen({
    Key? key,
    required this.barcode,
    this.productName = '',
    this.brand = '',
  }) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final picker = ImagePicker();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;
  bool isProductName = false;
  bool isBrand = false;
  bool isUploading = false;
  bool isUploaded = false;
  String userId = 'mycoding73@gmail.com';
  String password = 'Syedmoiz@1';
  String frontImg = '';
  String ingredientsImg = '';
  String neutientsImg = '';
  String bucketId = '64af8a9858e2c900f2e1';

  bool isImageFrontAvailable = true;

  bool isImageNutritionAvailable = true;

  bool isImageIngredientsAvailable = true;

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.barcode;
    _productNameController.text = widget.productName;
    _brandController.text = widget.brand;
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _productNameController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                            controller: _barcodeController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.barcode,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                enabled: widget.productName.isEmpty
                                    ? true
                                    : !isProductName
                                        ? false
                                        : true,
                                controller: _productNameController,
                                style: const TextStyle(fontSize: 16),
                                onChanged: (value) {
                                  setState(() {
                                    // Update the product name
                                    widget.productName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: widget.productName.isNotEmpty
                                      ? widget.productName
                                      : 'Enter product name',
                                ),
                              ),
                              if (widget.productName.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: !isProductName
                                        ? const Icon(Icons.edit)
                                        : const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        // Enable or disable editing
                                        isProductName = !isProductName;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                enabled: widget.brand.isEmpty
                                    ? true
                                    : !isBrand
                                        ? false
                                        : true,
                                controller: _brandController,
                                style: const TextStyle(fontSize: 16),
                                onChanged: (value) {
                                  setState(() {
                                    // Update the brand
                                    widget.brand = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      isBrand ? widget.brand : 'Enter brand',
                                ),
                              ),
                              if (widget.brand.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: !isBrand
                                        ? const Icon(Icons.edit)
                                        : const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        // Enable or disable editing
                                        isBrand = !isBrand;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Product Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ImageContainer(
                                image: _image1,
                                removeImage: () {
                                  setState(() {
                                    _image1 = null;
                                  });
                                },
                                imagePath: _image1 != null ? _image1!.path : '',
                                onImageSelected: () {
                                  _showImagePickerBottomSheet(
                                      context, 'image1');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              onPressed: () {
                                _showImagePickerBottomSheet(context, 'image1');
                              },
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Ingredients Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ImageContainer(
                                image: _image2,
                                removeImage: () {
                                  setState(() {
                                    _image2 = null;
                                  });
                                },
                                imagePath: _image2 != null ? _image2!.path : '',
                                onImageSelected: () {
                                  _showImagePickerBottomSheet(
                                      context, 'image2');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              onPressed: () {
                                _showImagePickerBottomSheet(context, 'image2');
                              },
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Nutrients Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ImageContainer(
                                image: _image3,
                                removeImage: () {
                                  setState(() {
                                    _image3 = null;
                                  });
                                },
                                imagePath: _image3 != null ? _image3!.path : '',
                                onImageSelected: () {
                                  _showImagePickerBottomSheet(
                                      context, 'image3');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              onPressed: () {
                                _showImagePickerBottomSheet(context, 'image3');
                              },
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: isUploading ? null : _uploadProduct,
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          if (isUploading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.7),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Product is uploading",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please wait...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (isUploaded)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.productName.isNotEmpty
                        ? "Product Updated Successfully!"
                        : "Product Uploaded Successfully!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    _getImageFromCamera(text);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    _getImageFromGallery(text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _getImageFromCamera(String text) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        switch (text) {
          case 'image1':
            _image1 = File(pickedFile.path);
            break;
          case 'image2':
            _image2 = File(pickedFile.path);
            break;
          case 'image3':
            _image3 = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _getImageFromGallery(String text) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        switch (text) {
          case 'image1':
            _image1 = File(pickedFile.path);
            break;
          case 'image2':
            _image2 = File(pickedFile.path);
            break;
          case 'image3':
            _image3 = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _uploadProduct() async {
    setState(() {
      isUploading = true;
    });

    if (_image1 != null && _image1!.path.isNotEmpty) {
      final front = await storage.createFile(
        bucketId: bucketId,
        fileId: uniqueId,
        file:
            InputFile.fromPath(path: _image1!.path, filename: 'frontImage.png'),
      );
      print('files created with ${front.$id}');
      setState(() {
        frontImg = front.$id;
      });
    }
    if (_image2 != null && _image2!.path.isNotEmpty) {
      final ingrident = await storage.createFile(
        bucketId: bucketId,
        fileId: uniqueId,
        file: InputFile.fromPath(
            path: _image2!.path, filename: 'ingredientsImage.png'),
      );
      print('files created with ${ingrident.$id}');
      setState(() {
        ingredientsImg = ingrident.$id;
      });
    }
    if (_image3 != null && _image3!.path.isNotEmpty) {
      final neutrient = await storage.createFile(
        bucketId: bucketId,
        fileId: uniqueId,
        file: InputFile.fromPath(
            path: _image3!.path, filename: 'neutientsImage.png'),
      );
      print('files created with ${neutrient.$id}');
      setState(() {
        neutientsImg = neutrient.$id;
      });
    }

    // await storage.getFileView(
    //   bucketId: '64af8a9858e2c900f2e1',
    //   fileId: frontImg,
    // );

    // frontGetFile.then((value) => {print(value)});
    print('all images has uploaded successfully');

    // Define the product to be added.
    Product myProduct = Product(
      barcode: widget.barcode,
      productName:
          isProductName ? widget.productName : _productNameController.text,
      brands: isBrand ? widget.brand : _brandController.text,
      // imageFrontUrl: frontImage,
      // imageIngredientsUrl: ingridentImage,
      // imageNutritionUrl: neutrientImage,
      // Add more attributes if available
    );

    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: userId, password: password);

    // Query the OpenFoodFacts API
    Status result = await OpenFoodAPIClient.saveProduct(myUser, myProduct);
    print('result ratus is ${result.status}');
    if (result.status == 1) {
      if (_image1 != null && _image1!.path.isNotEmpty) {
        await addProductImage(_image1!.uri, ImageField.FRONT);
      }
      if (_image2 != null && _image2!.path.isNotEmpty) {
        await addProductImage2(_image2!.uri, ImageField.INGREDIENTS);
        // await extractIngredient();
      }
      if (_image3 != null && _image3!.path.isNotEmpty) {
        await addProductImage3(_image3!.uri, ImageField.NUTRITION);
      }

      setState(() {
        isUploading = false;
        isUploaded = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isUploaded = false;
        });
        Navigator.pop(context);
      });
      print('product uploaded with this : ${result.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Product added'),
        ),
      );
      await storage.deleteFile(
        bucketId: bucketId,
        fileId: ingredientsImg,
      );
      await storage.deleteFile(
        bucketId: bucketId,
        fileId: frontImg,
      );
      await storage.deleteFile(
        bucketId: bucketId,
        fileId: neutientsImg,
      );
      print('all images deleted sucseefully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Product could not be added: ${result.error}'),
        ),
      );
    }
  }

  // Future<void> appwriteTest() async {
  //   try {
  //     final front = await storage.createFile(
  //       bucketId: '64af8a9858e2c900f2e1',
  //       fileId: uniqueId,
  //       file:
  //           InputFile.fromPath(path: _image1!.path, filename: 'frontImage.png'),
  //     );
  //     // final ingrident = await storage.createFile(
  //     //   bucketId: bucketId,
  //     //   fileId: uniqueId,
  //     //   file: InputFile.fromPath(path: _image1!.path, filename: 'frontImage.png'),
  //     // );
  //     // final neutrient = await storage.createFile(
  //     //   bucketId: '64ad58c02da944e86868',
  //     //   fileId: uniqueId,
  //     //   file: InputFile.fromPath(path: _image1!.path, filename: 'frontImage.png'),
  //     // );
  //     print('files created with ${front.$id}');
  //     setState(() {
  //       frontImg = front.$id;
  //       // ingredientsImg = ingrident.$id;
  //       // neutientsImg = neutrient.$id;
  //     });

  //     final frontGetFile = storage.getFileView(
  //       bucketId: '64af8a9858e2c900f2e1',
  //       fileId: frontImg,
  //     );
  //     final frontImage =
  //         'https://cloud.appwrite.io/v1/storage/buckets/64af8a9858e2c900f2e1/files/$frontImg/view?project=64ac1b54935437aa7538&mode=admin';
  //     // frontGetFile.then((value) => {print(value)});
  //     print(frontImage);
  //   } catch (e) {
  //     print('error occured $e');
  //   }
  // }

  Future<void> addProductImage(Uri imageUri, ImageField imageField) async {
    // Define the product image
    // Set the uri to the local image file
    // Choose the "imageField" as location/description of the image content.
    final frontImage =
        'https://cloud.appwrite.io/v1/storage/buckets/64af8a9858e2c900f2e1/files/$frontImg/preview?project=64ac1b54935437aa7538';
    Uri parseImage = Uri.parse(frontImage);

    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.FRONT,
      imageUri: parseImage,
    );
    print(parseImage);
    print(imageField);

    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: userId, password: password);

    // Query the OpenFoodFacts API
    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
              'Image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Image could not be uploaded: ${result.body} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Image added successfully'),
        ),
      );
    }
  }

  Future<void> addProductImage2(Uri imageUri, ImageField imageField) async {
    // Define the product image
    // Set the uri to the local image file
    // Choose the "imageField" as location/description of the image content.
    final ingridentImage =
        'https://cloud.appwrite.io/v1/storage/buckets/64af8a9858e2c900f2e1/files/$ingredientsImg/preview?project=64ac1b54935437aa7538';
    Uri parseImage = Uri.parse(ingridentImage);
    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.INGREDIENTS,
      imageUri: parseImage,
    );
    print(parseImage);
    print(imageField);

    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: userId, password: password);

    // Query the OpenFoodFacts API
    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
              'Image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Image could not be uploaded: ${result.error} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Image added successfully'),
        ),
      );
    }
  }

  Future<void> addProductImage3(Uri imageUri, ImageField imageField) async {
    // Define the product image
    // Set the uri to the local image file
    // Choose the "imageField" as location/description of the image content.
    final neutrientImage =
        'https://cloud.appwrite.io/v1/storage/buckets/64af8a9858e2c900f2e1/files/$neutientsImg/preview?project=64ac1b54935437aa7538';
    Uri parseImage = Uri.parse(neutrientImage);
    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.NUTRITION,
      imageUri: parseImage,
    );
    print(parseImage);
    print(imageField);

    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: userId, password: password);

    // Query the OpenFoodFacts API
    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
              'Image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Image could not be uploaded: ${result.error} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Image added successfully'),
        ),
      );
    }
  }

  Future<void> extractIngredient() async {
    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: userId, password: password);

    // Query the OpenFoodFacts API
    OcrIngredientsResult response = await OpenFoodAPIClient.extractIngredients(
      myUser,
      widget.barcode,
      OpenFoodFactsLanguage.ENGLISH,
    );

    if (response.status != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Text can't be extracted."),
        ),
      );
      throw Exception("Text can't be extracted.");
    } else {
      setState(() {
        isUploading = false;
      });
      print('Text extracted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Text extracted successfully"),
        ),
      );
    }
  }
}

class ImageContainer extends StatelessWidget {
  final File? image;
  final String imagePath;
  final VoidCallback removeImage;
  final VoidCallback onImageSelected;

  const ImageContainer({
    Key? key,
    required this.image,
    required this.imagePath,
    required this.removeImage,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (image != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Image.file(
              image!,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          )
        else if (imagePath.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(
              child: Text(
                'No Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        if (image != null || imagePath.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: removeImage,
              icon: const Icon(Icons.close),
              color: Colors.grey[700],
            ),
          ),
      ],
    );
  }
}
