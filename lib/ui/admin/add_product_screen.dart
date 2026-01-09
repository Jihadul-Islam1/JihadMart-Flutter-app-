import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jihad/const/AppColors.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // ImgBB API Key (Get one from https://api.imgbb.com/)
  // Note: For a real app, secure this key!
  final String _imgbbApiKey =
      "9e70dfbd00a0973b1705c4de1d670fc7"; // REPLACE THIS WITH YOUR KEY

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
      // You need to get a free API key from https://api.imgbb.com/
      // If you don't have one, the upload will fail.
      // For this demo, I'll assume you will put your key below.
      String apiKey = _imgbbApiKey;

      // If no key is provided, show error
      if (apiKey.contains("5555")) {
        Fluttertoast.showToast(
          msg: "Please set your ImgBB API Key in the code!",
        );
        return null;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload'),
      );
      request.fields['key'] = apiKey;
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

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageFile == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and pick an image");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Upload Image
      String? imageUrl = await _uploadImageToImgBB(_imageFile!);

      if (imageUrl == null) {
        Fluttertoast.showToast(msg: "Image upload failed. Check API Key.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      double price = double.parse(_priceController.text);

      // 2. Save to Firestore
      await FirebaseFirestore.instance.collection('products').add({
        "product-name": _nameController.text,
        "product-description": _descriptionController.text,
        "product-price": price,
        "product-img": [imageUrl], // Use the uploaded URL
        "created_at": FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Product added successfully!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding product: $e");
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
        title: Text("Add New Product"),
        backgroundColor: AppColors.deep_orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Picker UI
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Tap to pick image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
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
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deep_orange,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Add Product", style: TextStyle(fontSize: 18.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
