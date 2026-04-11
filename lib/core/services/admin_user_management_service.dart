import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

class AdminAccessActionResult {
  final bool success;
  final bool requiresManualStep;
  final String message;

  const AdminAccessActionResult({
    required this.success,
    required this.requiresManualStep,
    required this.message,
  });
}

class AdminUserManagementService {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  AdminUserManagementService({FirebaseFirestore? firestore, FirebaseFunctions? functions})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchUsers() {
    return _firestore
        .collection(FirestoreCollections.users)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<AdminAccessActionResult> setAdminAccess({
    required String email,
    required bool enableAdmin,
  }) async {
    try {
      final callable = _functions.httpsCallable('setUserAdminAccess');
      await callable.call(<String, dynamic>{
        'email': email,
        'enableAdmin': enableAdmin,
      });

      return const AdminAccessActionResult(
        success: true,
        requiresManualStep: false,
        message: 'Admin access updated.',
      );
    } on FirebaseFunctionsException catch (error) {
      final code = error.code.toLowerCase();
      final fallbackCodes = <String>{
        'not-found',
        'unimplemented',
        'unavailable',
        'internal',
      };

      if (fallbackCodes.contains(code)) {
        return AdminAccessActionResult(
          success: false,
          requiresManualStep: true,
          message:
              'Automatic role update is unavailable right now (${error.code}). Use the manual script command from this screen.',
        );
      }

      return AdminAccessActionResult(
        success: false,
        requiresManualStep: false,
        message: error.message ?? 'Update failed: ${error.code}',
      );
    } catch (error) {
      return AdminAccessActionResult(
        success: false,
        requiresManualStep: false,
        message: 'Update failed: $error',
      );
    }
  }
}