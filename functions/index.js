const admin = require('firebase-admin');
const functions = require('firebase-functions');

if (!admin.apps.length) {
  admin.initializeApp();
}

function requireAdmin(context) {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Login required.');
  }

  const email = (context.auth.token.email || '').toLowerCase();
  const isAdminClaim = context.auth.token.admin === true;
  const isHardcodedAdmin = email === 'admin@gmail.com';

  if (!isAdminClaim && !isHardcodedAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Admin access required.');
  }
}

exports.setUserAdminAccess = functions.https.onCall(async (data, context) => {
  requireAdmin(context);

  const email = String(data.email || '').trim().toLowerCase();
  const enableAdmin = Boolean(data.enableAdmin);

  if (!email) {
    throw new functions.https.HttpsError('invalid-argument', 'email is required');
  }

  const firestore = admin.firestore();
  const userDocRef = firestore.collection('users-form-data').doc(email);
  const userDocSnap = await userDocRef.get();
  const userDoc = userDocSnap.exists ? userDocSnap.data() : {};
  const currentRole = String(userDoc.role || 'customer').toLowerCase();
  const previousRole = String(userDoc.previousRole || '').toLowerCase();

  let authUser;
  try {
    authUser = await admin.auth().getUserByEmail(email);
  } catch (error) {
    throw new functions.https.HttpsError('not-found', `No Firebase Auth user found for ${email}`);
  }

  const currentClaims = authUser.customClaims || {};
  const nextClaims = { ...currentClaims };
  const batch = firestore.batch();

  if (enableAdmin) {
    nextClaims.admin = true;
    batch.set(
      userDocRef,
      {
        role: 'admin',
        previousRole: currentRole === 'admin' ? previousRole || 'customer' : currentRole,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  } else {
    delete nextClaims.admin;
    const restoredRole = previousRole || 'customer';
    batch.set(
      userDocRef,
      {
        role: restoredRole,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  }

  await admin.auth().setCustomUserClaims(authUser.uid, nextClaims);
  await batch.commit();

  return {
    ok: true,
    uid: authUser.uid,
    email,
    adminEnabled: enableAdmin,
    role: enableAdmin ? 'admin' : (previousRole || 'customer'),
  };
});