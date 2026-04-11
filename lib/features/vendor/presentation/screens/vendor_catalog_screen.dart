import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/config/app_config.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/core/services/product_repository.dart';

class VendorCatalogScreen extends StatefulWidget {
  const VendorCatalogScreen({super.key});

  @override
  State<VendorCatalogScreen> createState() => _VendorCatalogScreenState();
}

class _VendorCatalogScreenState extends State<VendorCatalogScreen> {
  final ProductRepository _repository = ProductRepository();

  String _readImgBBKey() {
    final configKey = AppConfig.imgbbApiKey.trim();
    if (configKey.isNotEmpty) {
      return configKey;
    }

    return const String.fromEnvironment('IMGBB_API_KEY', defaultValue: '').trim();
  }

  Future<Map<String, dynamic>?> _loadVendorContext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(user.email)
        .get();

    final data = userDoc.data();
    final storeId = data?['storeId']?.toString();
    if (storeId == null || storeId.isEmpty) {
      return null;
    }

    return {
      'storeId': storeId,
      'storeName': data?['storeName']?.toString() ?? 'My Store',
    };
  }

  void _openCreateProduct(Map<String, dynamic> vendorContext) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VendorProductFormScreen(
          storeId: vendorContext['storeId'] as String,
          storeName: vendorContext['storeName'] as String,
          imgbbApiKey: _readImgBBKey(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadVendorContext(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final vendorContext = snapshot.data;
        if (vendorContext == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F7FB),
            appBar: AppBar(
              title: const Text('My Catalog'),
              centerTitle: true,
              backgroundColor: AppColors.deepOrange,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Vendor access not activated yet. Submit the seller request and wait for admin approval.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            title: Text(vendorContext['storeName'] as String),
            centerTitle: true,
            backgroundColor: AppColors.deepOrange,
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.deepOrange,
            onPressed: () => _openCreateProduct(vendorContext),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _repository.watchStoreProducts(vendorContext['storeId'] as String),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Failed to load products: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64.sp, color: AppColors.deepOrange),
                        SizedBox(height: 12.h),
                        const Text('No products yet'),
                        SizedBox(height: 8.h),
                        const Text('Add your first product to start selling.'),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data();
                  final rawImages = data['product-img'];
                  final imageUrl = rawImages is List && rawImages.isNotEmpty
                      ? rawImages.first.toString()
                      : '';
                    final isNetworkImage = imageUrl.startsWith('http');

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.w),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          color: Colors.grey[200],
                          child: imageUrl.isEmpty
                              ? const Icon(Icons.image_not_supported)
                              : isNetworkImage
                                  ? Image.network(imageUrl, fit: BoxFit.cover)
                                  : Image.asset(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(
                        data['product-name']?.toString() ?? 'Unnamed product',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '৳${data['product-price'] ?? 0} • Stock ${data['stock'] ?? 0}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'delete') {
                            await _repository.deleteProduct(doc.id);
                            Fluttertoast.showToast(msg: 'Product deleted');
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorProductFormScreen(
                              storeId: vendorContext['storeId'] as String,
                              storeName: vendorContext['storeName'] as String,
                              productId: doc.id,
                              existingData: data,
                              imgbbApiKey: _readImgBBKey(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class VendorProductFormScreen extends StatefulWidget {
  final String storeId;
  final String storeName;
  final String imgbbApiKey;
  final String? productId;
  final Map<String, dynamic>? existingData;

  const VendorProductFormScreen({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.imgbbApiKey,
    this.productId,
    this.existingData,
  });

  @override
  State<VendorProductFormScreen> createState() => _VendorProductFormScreenState();
}

class _VendorProductFormScreenState extends State<VendorProductFormScreen> {
  static const String _defaultProductImage = 'assets/products/product1.jpg';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  final _categoryController = TextEditingController(text: 'General');
  final ImagePicker _picker = ImagePicker();
  final ProductRepository _repository = ProductRepository();

  File? _imageFile;
  String? _existingImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.existingData;
    if (data != null) {
      _nameController.text = data['product-name']?.toString() ?? '';
      _descriptionController.text = data['product-description']?.toString() ?? '';
      _priceController.text = data['product-price']?.toString() ?? '';
      _stockController.text = data['stock']?.toString() ?? '1';
      _categoryController.text = data['category']?.toString() ?? 'General';

      final rawImages = data['product-img'];
      if (rawImages is List && rawImages.isNotEmpty) {
        _existingImageUrl = rawImages.first.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    if (price <= 0 || stock < 0) {
      Fluttertoast.showToast(msg: 'Enter a valid price and stock');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? imageUrl = _existingImageUrl;
      if (_imageFile != null) {
        imageUrl = await _repository.uploadProductImage(
          imageFile: _imageFile!,
          apiKey: widget.imgbbApiKey,
        );

        if (imageUrl == null || imageUrl.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Image upload failed. Set IMGBB_API_KEY. Using default image.',
          );
        }
      }

      if (imageUrl == null || imageUrl.isEmpty) {
        imageUrl = _defaultProductImage;
      }

      if (widget.productId == null) {
        await _repository.createProduct(
          storeId: widget.storeId,
          storeName: widget.storeName,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          stock: stock,
          category: _categoryController.text.trim(),
          imageUrl: imageUrl,
        );
      } else {
        await _repository.updateProduct(
          productId: widget.productId!,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          stock: stock,
          category: _categoryController.text.trim(),
          imageUrl: imageUrl,
        );
      }

      if (!mounted) return;
      Fluttertoast.showToast(msg: widget.productId == null ? 'Product added' : 'Product updated');
      Navigator.pop(context);
    } on StateError catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } on FirebaseException catch (e) {
      final isPermissionIssue = e.code == 'permission-denied';
      Fluttertoast.showToast(
        msg: isPermissionIssue
            ? 'Permission denied: vendor/store role mismatch. Check Role Debug.'
            : 'Save failed: ${e.message ?? e.code}',
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Save failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingImage = _existingImageUrl;
    final isExistingNetwork = (existingImage ?? '').startsWith('http');

    final previewImage = _imageFile != null
        ? Image.file(_imageFile!, fit: BoxFit.cover)
      : (existingImage != null && existingImage.isNotEmpty
        ? isExistingNetwork
          ? Image.network(existingImage, fit: BoxFit.cover)
          : Image.asset(existingImage, fit: BoxFit.cover)
            : const Icon(Icons.add_a_photo, size: 40));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: previewImage,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildField('Product name', _nameController),
              SizedBox(height: 12.h),
              _buildField('Description', _descriptionController, maxLines: 4),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: _buildField('Price', _priceController, keyboardType: TextInputType.number)),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildField('Stock', _stockController, keyboardType: TextInputType.number)),
                ],
              ),
              SizedBox(height: 12.h),
              _buildField('Category', _categoryController),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.productId == null ? 'Save Product' : 'Update Product',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
    );
  }
}