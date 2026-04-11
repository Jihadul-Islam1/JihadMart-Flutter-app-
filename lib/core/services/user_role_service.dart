import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

enum AppRole { guest, customer, vendor, admin }

class UserRoleService {
  static const List<String> _adminEmails = ['admin@gmail.com'];

  static Future<AppRole> resolveCurrentRole() async {
    return resolveRole(FirebaseAuth.instance.currentUser);
  }

  static Future<AppRole> resolveRole(User? user) async {
    if (user == null) {
      return AppRole.guest;
    }

    final email = user.email?.trim().toLowerCase() ?? '';
    if (_adminEmails.contains(email)) {
      return AppRole.admin;
    }

    try {
      final idToken = await user.getIdTokenResult();
      if (idToken.claims?['admin'] == true) {
        return AppRole.admin;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(email)
          .get()
          .timeout(const Duration(seconds: 3));

      final data = snapshot.data();
      final role = (data?['role'] as String?)?.trim().toLowerCase();

      switch (role) {
        case 'admin':
          return AppRole.admin;
        case 'vendor':
        case 'seller':
          return AppRole.vendor;
        default:
          return AppRole.customer;
      }
    } catch (_) {
      return AppRole.customer;
    }
  }
}