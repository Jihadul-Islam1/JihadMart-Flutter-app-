# SSLCommerz Setup (Sandbox -> Live)

This project now uses `flutter_sslcommerz` for online payment methods in `lib/ui/payment_screen.dart`.

## 1) Add credentials

Create a `.env` file at the project root:

```env
SSLCOMMERZ_STORE_ID=your_sandbox_store_id
SSLCOMMERZ_STORE_PASSWORD=your_sandbox_store_password
SSLCOMMERZ_IS_SANDBOX=true
```

Alternative (without `.env`):

```bash
flutter run --dart-define=SSLCOMMERZ_STORE_ID=... --dart-define=SSLCOMMERZ_STORE_PASSWORD=... --dart-define=SSLCOMMERZ_IS_SANDBOX=true
```

## 2) Run dependencies

```bash
flutter pub get
```

## 2.1) Build APK correctly (important)

If payment works in `flutter run` but fails in installed APK, rebuild after setting credentials.

Option A (from `.env`):

- Keep `.env` at project root.
- Run `flutter clean` then `flutter build apk --release`.

Option B (recommended for release):

```bash
flutter build apk --release --dart-define=SSLCOMMERZ_STORE_ID=YOUR_STORE_ID --dart-define=SSLCOMMERZ_STORE_PASSWORD=YOUR_STORE_PASSWORD --dart-define=SSLCOMMERZ_IS_SANDBOX=true
```

For live mode, use `SSLCOMMERZ_IS_SANDBOX=false` and live credentials.

## 3) Test scenarios in sandbox

- Successful payment
- Failed payment
- Cancelled payment
- Wrong amount
- Network interruption during payment

Orders should be created only after successful SSLCommerz response.

## 4) Data saved in Firestore order

The order document now stores these payment fields when payment is successful:

- `paymentMethod`
- `paymentStatus`
- `paymentGateway`
- `paymentTransactionId`
- `paymentValidationId`
- `paymentBankTransactionId`
- `paymentRaw`

## 5) Go Live checklist

- Get live Store ID/password from SSLCommerz.
- Set `SSLCOMMERZ_IS_SANDBOX=false`.
- Replace sandbox credentials with live credentials.
- Perform low-amount smoke test in live mode.

## Important security note

Current integration is app-side and includes store credentials in runtime configuration.
For high-security production, move payment initialization + validation to backend and keep store password server-side only.
