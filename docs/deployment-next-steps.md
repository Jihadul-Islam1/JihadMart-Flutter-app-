# Deployment Next Steps

This file lists exactly what needs to be done outside the codebase.

## What is already done in code

- Firestore rules draft is present in firestore.rules
- Composite indexes file is present in firestore.indexes.json
- Firebase project config mapping is present in firebase.json

## External steps you must do

1. Install Firebase CLI (one-time)
- npm install -g firebase-tools

2. Login and select project
- firebase login
- firebase use --add
- Choose the project: jihad-ecommerce

3. Deploy Firestore rules and indexes
- firebase deploy --only firestore:rules
- firebase deploy --only firestore:indexes

4. Verify in Firebase Console
- Firestore Database -> Rules tab: confirm latest timestamp
- Firestore Database -> Indexes tab: confirm all indexes are building or enabled

5. Run app and verify queries
- flutter run
- Validate customer, vendor, and admin flows

## Recommended smoke test after deploy

1. Customer places order
2. Vendor sees order in vendor orders and updates status
3. Admin sees order in admin orders and uses action menu
4. Customer sees status updates in my orders/tracking and receives notifications
5. Customer submits refund request
6. Admin approves refund and marks refund paid
7. Audit logs record all transitions

## Notes

- If deploy command says project is not selected, run firebase use --add again.
- If indexes are still building, some queries may fail temporarily until index status becomes enabled.
