import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/services/audit_log_repository.dart';

class AdminAuditLogsScreen extends StatefulWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  State<AdminAuditLogsScreen> createState() => _AdminAuditLogsScreenState();
}

class _AdminAuditLogsScreenState extends State<AdminAuditLogsScreen> {
  final AuditLogRepository _repository = AuditLogRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedAction = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Audit Logs'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by actor, entity, or action',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                isDense: true,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 52.h,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('all', 'All'),
                _buildFilterChip('order_created', 'Order Created'),
                _buildFilterChip('order_status_changed', 'Order Status'),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _repository.watchAuditLogs(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load logs: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final query = _searchController.text.trim().toLowerCase();
                final docs = (snapshot.data?.docs ?? []).where((doc) {
                  final data = doc.data();
                  final action = data['action']?.toString().toLowerCase() ?? '';
                  if (_selectedAction != 'all' && action != _selectedAction) {
                    return false;
                  }

                  if (query.isEmpty) return true;

                  final actor = data['actorEmail']?.toString().toLowerCase() ?? '';
                  final entityType =
                      data['entityType']?.toString().toLowerCase() ?? '';
                  final entityId = data['entityId']?.toString().toLowerCase() ?? '';

                  return actor.contains(query) ||
                      entityType.contains(query) ||
                      entityId.contains(query) ||
                      action.contains(query);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(child: Text('No logs found'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final metadata = (data['metadata'] as Map?)?.cast<String, dynamic>() ??
                        const <String, dynamic>{};

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: AppColors.deepOrange,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  _prettyAction(data['action']?.toString() ?? ''),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDate(data['createdAt']),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Actor: ${data['actorEmail'] ?? 'system'}',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            'Entity: ${data['entityType'] ?? '-'} • ${data['entityId'] ?? '-'}',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                          ),
                          if (metadata.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              children: metadata.entries.map((entry) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
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

  Widget _buildFilterChip(String actionValue, String label) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        selected: _selectedAction == actionValue,
        label: Text(label),
        onSelected: (_) {
          setState(() {
            _selectedAction = actionValue;
          });
        },
      ),
    );
  }

  String _prettyAction(String value) {
    if (value.isEmpty) {
      return 'Unknown Action';
    }

    return value
        .split('_')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month ${date.year} $hour:$minute';
    }

    return 'just now';
  }
}
