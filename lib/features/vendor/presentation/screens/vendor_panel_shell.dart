import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/features/shared/presentation/screens/role_debug_screen.dart';
import 'package:jihad/features/shared/presentation/widgets/panel_placeholder_page.dart';
import 'package:jihad/features/vendor/presentation/screens/vendor_catalog_screen.dart';
import 'package:jihad/features/vendor/presentation/screens/vendor_orders_screen.dart';
import 'package:jihad/ui/login_screen.dart';

class VendorPanelShell extends StatefulWidget {
  const VendorPanelShell({super.key});

  @override
  State<VendorPanelShell> createState() => _VendorPanelShellState();
}

class _VendorPanelShellState extends State<VendorPanelShell> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout from vendor panel?'),
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
    const PanelPlaceholderPage(
      title: 'Vendor Overview',
      subtitle: 'Seller dashboard',
      icon: Icons.storefront_outlined,
      accentColor: AppColors.deepOrange,
      highlights: [
        'Live sales, revenue, and order cards',
        'Pending approvals and stock alerts',
        'Store health, rating, and campaign widgets',
      ],
    ),
    const VendorCatalogScreen(),
    const VendorOrdersScreen(),
    const PanelPlaceholderPage(
      title: 'Vendor Earnings',
      subtitle: 'Payouts and commissions',
      icon: Icons.payments_outlined,
      accentColor: Colors.purple,
      highlights: [
        'Commission summary and wallet balance',
        'Payout history and invoice reports',
        'Tax, fees, and settlement tracking',
      ],
    ),
    const PanelPlaceholderPage(
      title: 'Vendor Profile',
      subtitle: 'Store identity and settings',
      icon: Icons.person_outline,
      accentColor: Colors.teal,
      highlights: [
        'Store branding, policies, and contact info',
        'Team access and business verification',
        'Notifications, shipping, and payment setup',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) async {
          if (index == 5) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoleDebugScreen()),
            );
            return;
          }

          if (index == 6) {
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
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
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