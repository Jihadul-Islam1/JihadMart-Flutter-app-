import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/features/admin/presentation/screens/admin_audit_logs_screen.dart';
import 'package:jihad/features/admin/presentation/screens/admin_orders_screen.dart';
import 'package:jihad/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:jihad/features/shared/presentation/screens/role_debug_screen.dart';
import 'package:jihad/features/shared/presentation/widgets/panel_placeholder_page.dart';
import 'package:jihad/features/admin/presentation/screens/vendor_requests_screen.dart';
import 'package:jihad/ui/admin/admin_dashboard.dart';
import 'package:jihad/ui/login_screen.dart';

class AdminPanelShell extends StatefulWidget {
  const AdminPanelShell({super.key});

  @override
  State<AdminPanelShell> createState() => _AdminPanelShellState();
}

class _AdminPanelShellState extends State<AdminPanelShell> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout from admin panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  late final List<Widget> _pages = [
    const AdminDashboard(),
    const PanelPlaceholderPage(
      title: 'Catalogue Control',
      subtitle: 'Product governance',
      icon: Icons.inventory_outlined,
      accentColor: AppColors.deepOrange,
      highlights: [
        'Approve or reject products',
        'Manage categories, brands, banners, CMS',
        'Stock, pricing, and visibility controls',
      ],
    ),
    const PanelPlaceholderPage(
      title: 'Seller Management',
      subtitle: 'Vendor onboarding',
      icon: Icons.group_outlined,
      accentColor: Colors.blue,
      highlights: [
        'Verify sellers and assign roles',
        'Commission rules and payout status',
        'Store suspension and support actions',
      ],
    ),
    const AdminOrdersScreen(),
    const AdminUsersScreen(),
    const AdminAuditLogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _pages[0],
          _pages[1],
          const VendorRequestsScreen(),
          _pages[3],
          _pages[4],
          _pages[5],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) async {
          if (index == 6) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoleDebugScreen()),
            );
            return;
          }

          if (index == 7) {
            await _logout();
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            label: 'Catalogue',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            label: 'Sellers',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Audit Logs',
          ),
          NavigationDestination(
            icon: Icon(Icons.bug_report_outlined),
            label: 'Debug',
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_outlined),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}