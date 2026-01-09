import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/widgets/customButton.dart';

class EditProductScreen extends StatefulWidget {
  final QueryDocumentSnapshot product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _currentImageUrl;

  // ImgBB API Key
  final String _imgbbApiKey = "9e70dfbd00a0973b1705c4de1d670fc7";

  @override
  void initState() {
    super.initState();
    var data = widget.product.data() as Map<String, dynamic>;
    _nameController = TextEditingController(text: data['product-name']);
    _descriptionController = TextEditingController(
      text: data['product-description'],
    );
    _priceController = TextEditingController(
      text: data['product-price'].toString(),
    );

    // Handle image list or string
    if (data['product-img'] is List) {
      _currentImageUrl = (data['product-img'] as List).isNotEmpty
          ? (data['product-img'] as List)[0]
          : null;
    } else {
      _currentImageUrl = data['product-img'];
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToImgBB(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload'),
      );
      request.fields['key'] = _imgbbApiKey;
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var res = await request.send();
      if (res.statusCode == 200) {
        var responseData = await res.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = json.decode(responseString);
        return jsonResponse['data']['url'];
      } else {
        print("ImgBB Error: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all text fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _currentImageUrl;

      // If a new image is picked, upload it
      if (_imageFile != null) {
        imageUrl = await _uploadImageToImgBB(_imageFile!);
        if (imageUrl == null) {
          Fluttertoast.showToast(msg: "Image upload failed.");
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
            "product-name": _nameController.text,
            "product-description": _descriptionController.text,
            "product-price": _priceController
                .text, // Keep as string or parse to number if needed
            "product-img": [
              imageUrl,
            ], // Store as list to match existing structure
          });

      Fluttertoast.showToast(msg: "Product Updated Successfully!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: AppColors.deep_orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (_currentImageUrl != null
                            ? Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              )),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              _isLoading
                  ? CircularProgressIndicator()
                  : customButton("Update Product", _updateProduct),
            ],
          ),
        ),
      ),
    );
  }
}
