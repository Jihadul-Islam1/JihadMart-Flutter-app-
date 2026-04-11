# UAT Checklist

Use this checklist after every deployment.

## 1. Customer Flow

- Login as customer.
- Add products to cart.
- Checkout and place order.
- Verify order appears in My Orders and Tracking.

## 2. Vendor Flow

- Login as vendor account.
- Verify app opens vendor shell.
- Open Vendor Orders and update status in sequence:
  - Processing
  - Confirmed
  - Shipped
  - Out for Delivery
  - Delivered
- Verify customer receives updates.

## 3. Admin Flow

- Login as admin account.
- Open Sellers tab and approve pending vendor request.
- Open Orders tab and review all orders.
- Approve refund then mark refund paid.
- Verify audit logs for each action.

## 4. Data Checks (Firestore)

- orders collection:
  - status, statusHistory, refundStatus fields update correctly.
- notifications collection:
  - customer/vendor/admin notifications are created.
- payouts collection:
  - refund payout entry exists after refund paid.
- audit-logs collection:
  - order/refund actions recorded with actorEmail.

## 5. Role Checks

- Open Role Debug screen from Profile and verify:
  - resolvedRole
  - roleInDoc
  - storeId
  - admin claim

## 6. Logout Checks

- Customer logout works.
- Vendor logout works from vendor shell.
- Admin logout works from admin shell.

## 7. External/Manual Items

- Deploy rules and indexes after rules changes:
  - firebase deploy --only firestore:rules
  - firebase deploy --only firestore:indexes
- If using admin custom claim, set claim via backend/admin SDK.
