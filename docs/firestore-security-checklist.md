# Firestore Security Checklist

This checklist is for validating the current rules draft in firestore.rules before production rollout.

## 1. Emulator setup

- Install and login Firebase CLI.
- Run: firebase emulators:start --only firestore
- Use a dedicated test project and seed data for:
  - customer user document
  - vendor user document with storeId
  - admin user document/email
  - store, product, order, payout, notification, vendor-request records

## 2. Authentication scenarios

Validate all operations for each role:
- Guest (no auth)
- Customer
- Vendor
- Admin

Expected baseline:
- Guest cannot write any data.
- Guest can only read public product/store data.

## 3. Users collection tests

Collection: users-form-data
- Customer can read/write only own document.
- Vendor can read/write only own document.
- Admin can read/write all documents.
- Any non-admin delete must fail.

## 4. Product and store tests

Collections: products, stores
- Public read should succeed for products/stores.
- Vendor can create/update/delete product only for own storeId.
- Vendor cannot modify another vendor product/store.
- Admin can fully manage stores/products.

## 5. Orders tests

Collection: orders
- Customer can create order where userEmail == auth email.
- Customer can read/update only own orders.
- Vendor can read/update only orders containing vendor storeId in storeIds.
- Vendor cannot access orders of unrelated stores.
- Admin can read/update/delete all orders.

## 6. Refund workflow tests

Collection: orders and payouts
- Customer can request refund only on own order.
- Admin can approve refund.
- Admin can mark refund paid and create payout record.
- Vendor cannot mark refund paid.
- statusHistory and refund fields are updated correctly.

## 7. Notifications tests

Collection: notifications
- Customer reads/updates/deletes only own notifications.
- Vendor reads/updates/deletes only own notifications.
- Admin can read all notifications.
- Cross-user notification access must fail.

## 8. Vendor request tests

Collection: vendor-requests
- Customer can create request with own email only.
- Customer can read own request.
- Admin can read/update all requests.
- Non-admin cannot approve/reject.

## 9. Audit log tests

Collection: audit-logs
- Only admin can read logs.
- Authenticated user can create log only with actorEmail == auth email.
- Non-admin cannot edit/delete logs.

## 10. Negative and bypass tests

- Attempt writes with forged userEmail/storeId/actorEmail.
- Attempt updates that switch ownership fields.
- Attempt direct access with guessed document IDs.
- Validate all such attempts are denied.

## 11. Production hardening before go-live

- Move admin identity from hardcoded email to custom claims.
- Restrict order update fields by role (field-level validation).
- Restrict audit-log creation to backend (Cloud Functions) if possible.
- Add rate limiting and abuse monitoring.
- Add CI rule tests using Firebase Rules Unit Testing.
