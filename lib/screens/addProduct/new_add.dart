// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class AddProductPage extends StatefulWidget {
  String barcode;
  String productName;
  String brand;
  AddProductPage(
      {Key? key, required this.barcode, this.productName = '', this.brand = ''})
      : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _image1;
  File? _image2;
  File? _image3;
  final picker = ImagePicker();
  bool isUploading = false;
  bool isUploaded = false;
  bool isProductName = true;
  bool isBrand = true;
  String userId = 'mycoding73@gmail.com';
  String password = 'Syedmoiz@1';
  String productName = '';
  String brand = '';

  void _uploadProduct() {
    setState(() {
      isUploading = true;
      isUploaded = false;
    });

    addNewProduct(productName, brand).then(
      (_) => Future.delayed(
        const Duration(seconds: 0),
        () {
          setState(() {
            isUploading = false;
            isUploaded = true;
          });
        },
      ).then(
        (_) => Future.delayed(
          const Duration(seconds: 3),
          () {
            setState(() {
              isUploaded = false;
            });
          },
        ),
      ),
    );
  }

  Future<void> addNewProduct(String productName, String brand) async {
    Product myProduct = Product(
      barcode: widget.barcode,
      productName: isProductName ? widget.productName : productName,
      brands: isBrand ? widget.brand : brand,
    );

    User myUser = User(userId: userId, password: password);

    Status result = await OpenFoodAPIClient.saveProduct(myUser, myProduct);

    if (result.status == 1) {
      addProductImage();
      addIngredientsImage();
      addNutritionImage();
      extractIngredient();
      setState(() {
        isUploading = false;
        isUploaded = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Product added'),
        ),
      );
      print("Product added");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Product could not be added: ${result.error}'),
        ),
      );
      print('Product could not be added: ${result.error}');
    }
  }

  void addProductImage() async {
    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.FRONT,
      imageUri: _image1!.uri,
    );

    User myUser = User(userId: userId, password: password);

    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
              'Product image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Product image could not be uploaded: ${result.error} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Product image is added successfully'),
        ),
      );
      print('Product image is added successfully');
    }
  }

  void addIngredientsImage() async {
    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.INGREDIENTS,
      imageUri: _image2!.uri,
    );

    User myUser = User(userId: userId, password: password);

    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ingredients image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Ingredients image could not be uploaded: ${result.error} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Ingredients image is added successfully'),
        ),
      );
      print('Ingredients image is added successfully');
    }
  }

  void addNutritionImage() async {
    SendImage image = SendImage(
      lang: OpenFoodFactsLanguage.ENGLISH,
      barcode: widget.barcode,
      imageField: ImageField.NUTRITION,
      imageUri: _image3!.uri,
    );

    User myUser = User(userId: userId, password: password);

    Status result = await OpenFoodAPIClient.addProductImage(myUser, image);

    if (result.status != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
              'Nutrition image could not be uploaded: ${result.error} ${result.imageId.toString()}'),
        ),
      );
      throw Exception(
          'Nutrition image could not be uploaded: ${result.error} ${result.imageId.toString()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Nutrition image is added successfully'),
        ),
      );
      print('Nutrition image is added successfully');
    }
  }

  Future<String?> extractIngredient() async {
    User myUser = User(userId: userId, password: password);

    OcrIngredientsResult response = await OpenFoodAPIClient.extractIngredients(
        myUser, widget.barcode, OpenFoodFactsLanguage.ENGLISH);

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
    return response.ingredientsTextFromImage;
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
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BarcodeSection(barcode: widget.barcode),
                      const SizedBox(height: 16),
                      ProductNameSection(
                          productNameOrignal: widget.productName,
                          productName: productName),
                      const SizedBox(height: 16),
                      BrandSection(brandOrignal: widget.brand, brand: brand),
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
                                _showImagePickerBottomSheet(context, 'image1');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          FloatingActionButton(
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
                                _showImagePickerBottomSheet(context, 'image2');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          FloatingActionButton(
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
                                _showImagePickerBottomSheet(context, 'image3');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          FloatingActionButton(
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
        },
      ),
    );
  }
}

class BarcodeSection extends StatelessWidget {
  String barcode;
  BarcodeSection({Key? key, required this.barcode}) : super(key: key);

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
            controller: TextEditingController(text: barcode),
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

class ProductNameSection extends StatefulWidget {
  String productNameOrignal;
  String productName;
  ProductNameSection(
      {Key? key, required this.productNameOrignal, required this.productName})
      : super(key: key);

  @override
  _ProductNameSectionState createState() => _ProductNameSectionState();
}

class _ProductNameSectionState extends State<ProductNameSection> {
  // String productName = '';
  bool isProductName = true;
  late String productName = '';
  final _productNameController = TextEditingController();
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
        GestureDetector(
          onTap: () {
            _showEditDialog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                TextField(
                  enabled: widget.productName == ''
                      ? true
                      : isProductName
                          ? false
                          : true,
                  controller: _productNameController,
                  style: const TextStyle(fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      productName = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isProductName
                        ? widget.productName
                        : 'Enter product name',
                  ),
                ),
                if (widget.productName.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editingController =
            TextEditingController(text: widget.productName);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit Product Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: editingController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.text_fields),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter product name',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.productName = editingController.text;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BrandSection extends StatefulWidget {
  String brandOrignal;
  String brand;
  BrandSection({Key? key, required this.brandOrignal, required this.brand})
      : super(key: key);

  @override
  _BrandSectionState createState() => _BrandSectionState();
}

class _BrandSectionState extends State<BrandSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Brand",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showEditDialog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                TextField(
                  enabled: false,
                  controller: TextEditingController(text: widget.brand),
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.brand.isEmpty
                        ? widget.brandOrignal.isNotEmpty
                            ? widget.brandOrignal
                            : 'Enter brand'
                        : widget.brand,
                  ),
                ),
                if (widget.brand.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editingController =
            TextEditingController(text: widget.brand);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit Brand',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: editingController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.text_fields),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter brand name',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.brand = editingController.text;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

class UploadProgressOverlay extends StatelessWidget {
  const UploadProgressOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UploadSuccessOverlay extends StatelessWidget {
  const UploadSuccessOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Product Uploaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
