# Jihad Mart

Jihad Mart is a Flutter-based ecommerce app built on Firebase. It supports customer shopping, vendor catalog management, and admin operations in a single codebase.

## What It Includes

- Customer authentication with email/password, phone OTP, Google sign-in, Facebook login, and email OTP.
- Product browsing, search, product details, cart, checkout, and order tracking.
- Live Firestore-backed orders, notifications, and order status updates.
- Vendor tools for onboarding, catalog management, and vendor-specific order queues.
- Admin tools for user management, catalog oversight, orders, and audit logs.
- AI chat support powered by Google Gemini.
- SSLCommerz online payments.
- Vendor image uploads through ImgBB.

## Requirements

- Flutter SDK 3.9 or newer.
- A configured Firebase project for the app.
- Android Studio, VS Code, or another Flutter-compatible IDE.

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Make sure Firebase is configured for the platforms you want to run.

3. Add your runtime configuration in a `.env` file at the project root or pass values with `--dart-define`.

4. Run the app:

```bash
flutter run
```

## Environment Variables

`lib/core/config/app_config.dart` reads these values from `--dart-define` first, then from `.env` if available:

```env
IMGBB_API_KEY=your_imgbb_key
SSLCOMMERZ_STORE_ID=your_store_id
SSLCOMMERZ_STORE_PASSWORD=your_store_password
SSLCOMMERZ_IS_SANDBOX=true
EMAIL_OTP_APP_NAME=Jihad Mart
EMAIL_OTP_APP_EMAIL=your_smtp_sender@example.com
EMAIL_OTP_SMTP_HOST=smtp.gmail.com
EMAIL_OTP_SMTP_USERNAME=your_smtp_username@example.com
EMAIL_OTP_SMTP_PASSWORD=your_smtp_app_password
EMAIL_OTP_SMTP_PORT=587
EMAIL_OTP_SMTP_SECURE_TYPE=tls
GEMINI_API_KEY=your_gemini_key
```

You can also pass values directly when launching Flutter:

```bash
flutter run --dart-define=IMGBB_API_KEY=your_imgbb_key --dart-define=SSLCOMMERZ_STORE_ID=your_store_id --dart-define=SSLCOMMERZ_STORE_PASSWORD=your_store_password
```

## Firebase Notes

- Firebase is initialized from the splash flow.
- Firestore is used for products, orders, notifications, roles, vendor requests, and audit logs.
- Cloud Functions are referenced by the app for admin and role-management workflows.

## Project Structure

- `lib/app` - app bootstrap and shell widgets.
- `lib/core` - config, models, constants, and repositories.
- `lib/features` - customer, vendor, admin, and shared feature screens.
- `lib/ui` - legacy and shared UI screens.
- `lib/utils` - service classes and helpers.
- `docs` - setup and project notes.

## Useful Docs

- [SSLCommerz setup](docs/sslcommerz-setup.md)
- [Firestore schema](docs/firestore-schema.md)
- [Firestore security checklist](docs/firestore-security-checklist.md)
- [Deployment next steps](docs/deployment-next-steps.md)

## Notes

- For Gmail SMTP, use an app password instead of your normal account password.
- If you are testing payments, keep `SSLCOMMERZ_IS_SANDBOX=true` until you switch to live credentials.
