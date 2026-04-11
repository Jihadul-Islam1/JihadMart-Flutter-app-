const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

function printUsageAndExit() {
  console.log(`
Usage:
  node scripts/set_admin_claim.js --service-account C:\\path\\to\\serviceAccountKey.json --email user@example.com
  node scripts/set_admin_claim.js --service-account C:\\path\\to\\serviceAccountKey.json --uid firebaseUid
  node scripts/set_admin_claim.js --service-account C:\\flutter\\jihad-ecommerce-firebase-adminsdk-fbsvc-02e21f3f31.json --email jihad1@gmail.com
  node scripts/set_admin_claim.js --service-account C:\\flutter\\jihad-ecommerce-firebase-adminsdk-fbsvc-02e21f3f31.json --email jihad1@gmail.com --remove
Optional:
  --role admin   Default is admin
  --remove       Remove the admin claim instead of setting it

Env alternative:
  FIREBASE_SERVICE_ACCOUNT=C:\\path\\to\\serviceAccountKey.json
`);
  process.exit(1);
}

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i++) {
    const arg = argv[i];
    if (!arg.startsWith('--')) continue;
    const key = arg.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith('--')) {
      args[key] = true;
    } else {
      args[key] = next;
      i++;
    }
  }
  return args;
}

async function main() {
  const args = parseArgs(process.argv);
  const serviceAccountPath = args['service-account'] || process.env.FIREBASE_SERVICE_ACCOUNT;
  const email = args.email;
  const uid = args.uid;
  const role = args.role || 'admin';
  const remove = Boolean(args.remove);

  if (!serviceAccountPath || (!email && !uid)) {
    printUsageAndExit();
  }

  const resolvedServiceAccountPath = path.resolve(serviceAccountPath);
  if (!fs.existsSync(resolvedServiceAccountPath)) {
    throw new Error(`Service account file not found: ${resolvedServiceAccountPath}`);
  }

  const serviceAccount = require(resolvedServiceAccountPath);
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }

  let userRecord;
  if (uid) {
    userRecord = await admin.auth().getUser(uid);
  } else {
    userRecord = await admin.auth().getUserByEmail(email);
  }

  const currentClaims = userRecord.customClaims || {};
  const nextClaims = { ...currentClaims };

  if (remove) {
    delete nextClaims.admin;
  } else {
    nextClaims.admin = role === 'admin' ? true : role;
  }

  await admin.auth().setCustomUserClaims(userRecord.uid, nextClaims);

  console.log('Admin claim updated successfully.');
  console.log(`UID: ${userRecord.uid}`);
  console.log(`Email: ${userRecord.email || '-'}`);
  console.log(`Claims: ${JSON.stringify(nextClaims)}`);
  console.log('Important: the user must sign out and sign back in for the new claim to take effect.');
}

main().catch((error) => {
  console.error('Failed to update admin claim.');
  console.error(error);
  process.exit(1);
});
