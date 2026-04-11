import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/core/services/user_role_service.dart';

class RoleDebugScreen extends StatefulWidget {
  const RoleDebugScreen({super.key});

  @override
  State<RoleDebugScreen> createState() => _RoleDebugScreenState();
}

class _RoleDebugScreenState extends State<RoleDebugScreen> {
  Future<Map<String, dynamic>> _loadDebugInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final result = <String, dynamic>{
      'uid': user?.uid,
      'email': user?.email,
      'resolvedRole': AppRole.guest.name,
      'roleInDoc': null,
      'storeId': null,
      'isAdminClaim': false,
    };

    if (user == null) {
      return result;
    }

    final role = await UserRoleService.resolveRole(user);
    result['resolvedRole'] = role.name;

    final token = await user.getIdTokenResult(true);
    result['isAdminClaim'] = token.claims?['admin'] == true;

    final email = user.email?.trim().toLowerCase();
    if (email != null && email.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(email)
          .get();

      final data = doc.data();
      result['roleInDoc'] = data?['role'];
      result['storeId'] = data?['storeId'];
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Role Debug'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDebugInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? const <String, dynamic>{};

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _kvTile('UID', data['uid']),
              _kvTile('Email', data['email']),
              _kvTile('Resolved Role', data['resolvedRole']),
              _kvTile('Role In Firestore Doc', data['roleInDoc']),
              _kvTile('Store ID', data['storeId']),
              _kvTile('Admin Claim', data['isAdminClaim']),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepOrange,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kvTile(String label, dynamic value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value?.toString() ?? '-'),
          ),
        ],
      ),
    );
  }
}
