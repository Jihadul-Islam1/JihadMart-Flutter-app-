import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/services/admin_user_management_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final AdminUserManagementService _service = AdminUserManagementService();
  static const String _serviceAccountPathPlaceholder =
      'C:\\flutter\\jihad-ecommerce-firebase-adminsdk-fbsvc-02e21f3f31.json';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _busyEmails = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _manualCommand({required String email, required bool enableAdmin}) {
    final actionFlag = enableAdmin ? '' : ' --remove';
    return 'node scripts/set_admin_claim.js --service-account '
        '$_serviceAccountPathPlaceholder --email $email$actionFlag';
  }

  Future<void> _showManualFallbackDialog({
    required String email,
    required bool enableAdmin,
    required String reason,
  }) async {
    final command = _manualCommand(email: email, enableAdmin: enableAdmin);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Manual Mode Required'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reason),
              SizedBox(height: 10.h),
              const Text('Run this command in project root:'),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SelectableText(
                  command,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
              SizedBox(height: 10.h),
              const Text('Then the target user must sign out and sign in again.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleAdminRole({
    required String email,
    required bool enableAdmin,
    required String displayName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(enableAdmin ? 'Make Admin' : 'Remove Admin'),
        content: Text(
          enableAdmin
              ? 'Give admin access to $displayName?'
              : 'Remove admin access from $displayName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(enableAdmin ? 'Make Admin' : 'Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _busyEmails.add(email);
    });

    try {
      final result = await _service.setAdminAccess(
        email: email,
        enableAdmin: enableAdmin,
      );
      if (!mounted) return;
      if (result.success) {
        Fluttertoast.showToast(
          msg: enableAdmin ? 'Admin access granted' : 'Admin access removed',
        );
      } else if (result.requiresManualStep) {
        await _showManualFallbackDialog(
          email: email,
          enableAdmin: enableAdmin,
          reason: result.message,
        );
      } else {
        Fluttertoast.showToast(msg: result.message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _busyEmails.remove(email);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by name or email',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _service.watchUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load users: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? const [];
                final filteredDocs = docs.where((doc) {
                  final data = doc.data();
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final email = (data['email'] ?? doc.id).toString().toLowerCase();
                  return _searchQuery.isEmpty ||
                      name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data();
                    final email = (data['email'] ?? doc.id).toString();
                    final name = (data['name'] ?? 'Unknown User').toString();
                    final role = (data['role'] ?? 'customer').toString().toLowerCase();
                    final storeId = (data['storeId'] ?? '').toString();
                    final isAdmin = role == 'admin';
                    final isBusy = _busyEmails.contains(email.toLowerCase());

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: AppColors.deepOrange.withOpacity(0.12),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: AppColors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: [
                                    _roleChip(role),
                                    if (storeId.isNotEmpty) _infoChip('Store: $storeId'),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: isBusy
                                            ? null
                                            : () => _toggleAdminRole(
                                                  email: email,
                                                  enableAdmin: !isAdmin,
                                                  displayName: name,
                                                ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isAdmin
                                              ? Colors.redAccent
                                              : AppColors.deepOrange,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: Icon(
                                          isBusy
                                              ? Icons.hourglass_top
                                              : isAdmin
                                                  ? Icons.remove_moderator_outlined
                                                  : Icons.admin_panel_settings_outlined,
                                        ),
                                        label: Text(
                                          isBusy
                                              ? 'Updating...'
                                              : isAdmin
                                                  ? 'Remove Admin'
                                                  : 'Make Admin',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String role) {
    final color = switch (role) {
      'admin' => Colors.red,
      'vendor' || 'seller' => Colors.blue,
      _ => Colors.grey,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}