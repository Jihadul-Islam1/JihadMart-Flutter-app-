# Firestore Schema

This project is currently using Firestore as the fastest path to a working backend. The schema below is the shared contract for the customer, vendor, and admin panels.

## Collections

### `users-form-data`

Purpose: user profile and role information.

Fields:
- `id` string
- `email` string
- `name` string
- `phone` string
- `role` string: `customer`, `vendor`, or `admin`
- `previousRole` string, optional, used when temporarily promoting a user to admin
- `storeId` string, optional
- `gender` string, optional
- `dob` string, optional
- `age` string, optional
- `photoUrl` string, optional
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `stores`

Purpose: vendor store profile.

Fields:
- `id` string
- `ownerId` string
- `ownerEmail` string
- `name` string
- `slug` string
- `description` string
- `logoUrl` string
- `status` string: `active`, `pending`, `suspended`
- `phone` string
- `address` string
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `products`

Purpose: catalogue items.

Fields:
- `id` string
- `storeId` string
- `name` string
- `description` string
- `price` number
- `images` array of strings
- `category` string
- `brand` string
- `stock` number
- `status` string: `active`, `draft`, `archived`
- `variants` map, optional
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `orders`

Purpose: customer order lifecycle.

Fields:
- `id` string
- `orderId` string, human readable code
- `userId` string
- `userEmail` string
- `storeIds` array of strings
- `items` array of item maps
- `subtotalAmount` number
- `shippingAmount` number
- `taxAmount` number
- `discountAmount` number
- `totalAmount` number
- `paymentMethod` string
- `status` string: `processing`, `confirmed`, `shipped`, `out for delivery`, `delivered`, `cancelled`, `refunded`
- `shippingAddress` string
- `statusHistory` array of maps: status transition timeline
- `refundStatus` string, optional: `requested`, `approved`, `paid`
- `refundReason` string, optional
- `refundRequestedBy` string, optional
- `refundRequestedAt` timestamp/string, optional
- `refundApprovedBy` string, optional
- `refundApprovedAt` timestamp/string, optional
- `refundApprovalNote` string, optional
- `refundPaidAt` timestamp/string, optional
- `refundPayoutId` string, optional
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `users-favourite-items`

Purpose: wishlist items, currently used by the app.

Recommended structure:
- document id = user email or uid
- subcollection `items`

### `vendor-requests`

Purpose: vendor onboarding and approval.

Fields:
- `id` string
- `userId` string
- `email` string
- `storeName` string
- `businessType` string
- `status` string: `pending`, `approved`, `rejected`
- `createdAt` timestamp/string
- `reviewedAt` timestamp/string, optional
- `rejectionReason` string, optional

Approval behavior:
- When approved, the user's `role` becomes `vendor`.
- A `stores` document is created for the vendor.
- The user document receives `storeId`.

### `subscriptions`

Purpose: SaaS plan billing.

Fields:
- `id` string
- `storeId` string
- `planId` string
- `status` string
- `startsAt` timestamp/string
- `endsAt` timestamp/string
- `limits` map

### `payouts`

Purpose: vendor earnings and settlement.

Fields:
- `id` string
- `storeId` string, optional
- `orderId` string
- `amount` number
- `type` string: `refund`, `vendor_settlement`
- `status` string: `pending`, `paid`, `failed`
- `paidTo` string, optional
- `paidBy` string, optional
- `note` string, optional
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `notifications`

Purpose: in-app notifications for customer/vendor/admin.

Fields:
- `id` string
- `userEmail` string
- `title` string
- `message` string
- `type` string: `order`, `refund`, `promo`, `payment`, `system`
- `isRead` bool
- `metadata` map
- `createdAt` timestamp/string
- `updatedAt` timestamp/string

### `audit-logs`

Purpose: admin traceability.

Fields:
- `id` string
- `actorUid` string
- `actorEmail` string
- `action` string
- `entityType` string
- `entityId` string
- `metadata` map
- `createdAt` timestamp/string

## Migration order

1. Keep current UI working with existing collections.
2. Start writing new data with the schema above.
3. Add repository classes that map Firestore snapshots to the typed models.
4. Gradually replace raw map access in the UI.
