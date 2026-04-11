import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:jihad/core/constants/firestore_collections.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchStoreProducts(String storeId) {
    return _firestore
        .collection(FirestoreCollections.products)
        .where('storeId', isEqualTo: storeId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<String?> uploadImageToImgBB({
    required File imageFile,
    required String apiKey,
  }) async {
    final trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) {
      return null;
    }

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('https://api.imgbb.com/1/upload'),
      body: {
        'key': trimmedKey,
        'image': base64Image,
        'name': imageFile.uri.pathSegments.isNotEmpty
            ? imageFile.uri.pathSegments.last.split('.').first
            : 'product_image',
      },
    );

    final responseString = response.body;
    if (response.statusCode != 200) {
      throw StateError('ImgBB upload failed (${response.statusCode}): $responseString');
    }

    final jsonResponse = json.decode(responseString) as Map<String, dynamic>;
    final data = jsonResponse['data'] as Map<String, dynamic>?;
    final url = (data?['display_url'] ?? data?['url'])?.toString();
    if (url == null || url.isEmpty) {
      throw StateError('ImgBB response did not include a valid image URL.');
    }

    return url;
  }

  Future<String?> uploadProductImage({
    required File imageFile,
    required String apiKey,
  }) async {
    return uploadImageToImgBB(
      imageFile: imageFile,
      apiKey: apiKey,
    );
  }

  Future<void> createProduct({
    required String storeId,
    required String storeName,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String imageUrl,
  }) async {
    final productId = _firestore.collection(FirestoreCollections.products).doc().id;

    await _firestore.collection(FirestoreCollections.products).doc(productId).set({
      'id': productId,
      'storeId': storeId,
      'storeName': storeName,
      'product-name': name,
      'product-description': description,
      'product-price': price,
      'product-img': [imageUrl],
      'category': category,
      'stock': stock,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{
      'product-name': name,
      'product-description': description,
      'product-price': price,
      'category': category,
      'stock': stock,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (imageUrl != null) {
      data['product-img'] = [imageUrl];
    }

    await _firestore.collection(FirestoreCollections.products).doc(productId).update(data);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(FirestoreCollections.products).doc(productId).delete();
  }
}