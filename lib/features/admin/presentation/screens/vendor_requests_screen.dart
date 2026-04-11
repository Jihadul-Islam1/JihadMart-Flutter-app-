import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/services/vendor_approval_service.dart';

class VendorRequestsScreen extends StatefulWidget {
  const VendorRequestsScreen({super.key});

  @override
  State<VendorRequestsScreen> createState() => _VendorRequestsScreenState();
}

class _VendorRequestsScreenState extends State<VendorRequestsScreen> {
  final VendorApprovalService _service = VendorApprovalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Vendor Requests'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: _service.watchPendingRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load requests: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data?.docs ?? [];
          if (requests.isEmpty) {
            return const Center(child: Text('No pending vendor requests'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data();
              final requestId = data['id']?.toString() ?? requests[index].id;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor: AppColors.deepOrange.withOpacity(0.1),
                          child: Icon(Icons.storefront_outlined, color: AppColors.deepOrange),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['storeName']?.toString() ?? 'Unknown Store',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['email']?.toString() ?? '',
                                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text('Owner: ${data['name'] ?? '-'}'),
                    Text('Phone: ${data['phone'] ?? '-'}'),
                    Text('Business type: ${data['businessType'] ?? '-'}'),
                    if ((data['description'] ?? '').toString().isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        data['description'].toString(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              try {
                                await _service.rejectRequest(requestId: requestId);
                                if (!mounted) return;
                                Fluttertoast.showToast(msg: 'Request rejected');
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'Reject failed: $e');
                              }
                            },
                            child: const Text('Reject'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await _service.approveRequest(
                                  requestId: requestId,
                                  userId: data['userId']?.toString() ?? '',
                                  email: data['email']?.toString() ?? '',
                                  storeName: data['storeName']?.toString() ?? '',
                                  name: data['name']?.toString() ?? '',
                                  phone: data['phone']?.toString() ?? '',
                                  businessType: data['businessType']?.toString() ?? '',
                                );
                                if (!mounted) return;
                                Fluttertoast.showToast(msg: 'Vendor approved');
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'Approve failed: $e');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepOrange,
                            ),
                            child: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}