# Project Structure

This app is now organized around three clear panels:

- Customer panel: shopping, checkout, profile, and support
- Vendor panel: catalogue, orders, earnings, and store management
- Admin panel: platform dashboard, catalogue control, sellers, and operations

## Current layout

```text
lib/
  app/
    ecommerce_app.dart
  core/
    constants/
      firestore_collections.dart
    models/
      app_user.dart
      app_order.dart
      product_item.dart
      store_profile.dart
    services/
      user_role_service.dart
  features/
    customer/
      presentation/screens/customer_panel_shell.dart
    vendor/
      presentation/screens/vendor_panel_shell.dart
    admin/
      presentation/screens/admin_panel_shell.dart
    shared/
      presentation/screens/role_gate_screen.dart
      presentation/widgets/panel_placeholder_page.dart
  ui/
    existing screens and flows
  widgets/
  utils/
```

## Entry flow

1. `main.dart` launches `EcommerceApp`
2. `SplashScreen` waits briefly and opens `RoleGateScreen`
3. `RoleGateScreen` routes to customer, vendor, admin, or login

## What should be built next

1. Replace in-memory cart/order data with Firestore or a backend API.
2. Add vendor registration and role assignment.
3. Move product CRUD into a real vendor catalogue module.
4. Add proper admin authorization and audit logging.
5. Standardize Firestore schemas for products, orders, users, and stores.
