import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null; // User canceled the sign-in

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
        return await _auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      debugPrint('Google Sign In platform error: ${e.code} ${e.message}');
      Fluttertoast.showToast(msg: "Google Sign In error: ${e.code}");
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Google FirebaseAuthException: ${e.code} ${e.message}');
      Fluttertoast.showToast(msg: "Google auth failed: ${e.code}");
      return null;
    } catch (e) {
      debugPrint('Google Sign In Failed: $e');
      Fluttertoast.showToast(msg: "Google Sign In Failed: $e");
      return null;
    }
  }

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
        loginBehavior: LoginBehavior.nativeWithFallback,
      );

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        if (accessToken == null || accessToken.tokenString.isEmpty) {
          Fluttertoast.showToast(msg: 'Facebook token missing. Please try again.');
          return null;
        }

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Once signed in, return the UserCredential
        return await _auth.signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        Fluttertoast.showToast(msg: "Facebook Login Cancelled");
        return null;
      } else {
        Fluttertoast.showToast(
          msg: "Facebook Login Failed: ${result.message ?? result.status.name}",
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Facebook FirebaseAuthException: ${e.code} ${e.message}');
      Fluttertoast.showToast(msg: "Facebook auth failed: ${e.code}");
      return null;
    } on PlatformException catch (e) {
      debugPrint('Facebook platform error: ${e.code} ${e.message}');
      Fluttertoast.showToast(msg: "Facebook platform error: ${e.code}");
      return null;
    } catch (e) {
      debugPrint('Facebook Sign In Error: $e');
      Fluttertoast.showToast(msg: "Facebook Sign In Error: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}
