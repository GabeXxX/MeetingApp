//TODO: implement login methods
//TODO: implements text controller methods

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:secret_essential/models/user_model.dart';
import 'package:secret_essential/services/firebase_auth_service.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel({@required this.authService});

  final FirebaseAuthService authService;
  bool isLoading = false;
  String message = "";

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      return await signInMethod();
    } catch (e) {
      isLoading = false;
      message = e.toString();
      print(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    return _signIn(
        () => authService.signInWithEmailAndPassword(email, password));
  }

  Future<User> signInWithGoogle() async {
    return _signIn(() => authService.signInWithGoogle());
  }

  Future<User> register(String email, String password) async {
    return _signIn(
        () => authService.createUserWithEmailAndPassword(email, password));
  }

  String emailValidator(String email) {
    if (email.isEmpty) {
      return "Please enter email";
    }
    String emailVal =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (!email.contains(new RegExp(emailVal)))
      return "Pleas insert a valid email";
    return null;
  }

  String passwordValidator(String password) {
    if (password.isEmpty) return "Please insert password";
    if (password.length < 6) return "Please insert a correct password";
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      message = "A reset link as been sent to your email";
      notifyListeners();
      return await authService.sendPasswordResetEmail(email);
    } catch (e) {
      message = e.toString();
      notifyListeners();
      print(e.toString());
      rethrow;
    }
  }
}
