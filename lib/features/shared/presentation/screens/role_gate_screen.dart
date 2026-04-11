import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jihad/core/services/user_role_service.dart';
import 'package:jihad/features/admin/presentation/screens/admin_panel_shell.dart';
import 'package:jihad/features/customer/presentation/screens/customer_panel_shell.dart';
import 'package:jihad/features/vendor/presentation/screens/vendor_panel_shell.dart';
import 'package:jihad/ui/login_screen.dart';

class RoleGateScreen extends StatelessWidget {
  const RoleGateScreen({super.key});

  static const Duration _resolveTimeout = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppRole>(
      future: UserRoleService.resolveCurrentRole().timeout(
        _resolveTimeout,
        onTimeout: () {
          final user = FirebaseAuth.instance.currentUser;
          return user == null ? AppRole.guest : AppRole.customer;
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _RoleGateLoadingScreen();
        }

        if (snapshot.hasError) {
          return const LoginScreen();
        }

        final role = snapshot.data ?? AppRole.guest;

        switch (role) {
          case AppRole.admin:
            return const AdminPanelShell();
          case AppRole.vendor:
            return const VendorPanelShell();
          case AppRole.customer:
            return const CustomerPanelShell();
          case AppRole.guest:
            return const LoginScreen();
        }
      },
    );
  }
}

class _RoleGateLoadingScreen extends StatelessWidget {
  const _RoleGateLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}