import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Pages/Login/verification.dart';
import '../Utils/colors.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final snackBar = SnackBar(
  dismissDirection: DismissDirection.down,
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  backgroundColor: transparent,
  content: AwesomeSnackbarContent(
    title: 'Google Login Failed',
    message: 'Re-Try Google Login !!',
    contentType: ContentType.failure,
  ),
);

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSiginIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSiginIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)..showSnackBar(snackBar);
      successfulAnimation = false;
      throw e;
    }
  }

  signOutWithGoogle(context) async {
    await _auth.signOut();
    await _googleSiginIn.signOut();
  }

  createUserWithEmailAndPassword(
      {required String email, required String password}) {}
}

Future<bool> signInWithEmailAndPassword(
    {required email, required password}) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> createUserWithEmailAndPassword(
    {required email, required password}) async {
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
