import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'r_t_d_b_service.dart';
import 'db_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static String verificationId = '';

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login( );

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel? userModel = await RTDBService.loadUser(_auth.currentUser!.uid);
      await DBService.saveUser(userModel!);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<UserCredential> createUser(String email, String password) async {
    _auth.signOut();
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> verifyEmail(String email) async {
    await _auth.currentUser?.sendEmailVerification();

    // await _auth.sendSignInLinkToEmail(
    //     email: email,
    //     actionCodeSettings: ActionCodeSettings(
    //       url: 'https://testapp-womens.firebaseapp.com',
    //       androidInstallApp: true,
    //       handleCodeInApp: true,
    // ));
    debugPrint('email=${_auth.currentUser?.email}');

  }

  static Future<bool> verifyEmailLink() async {
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }
}
