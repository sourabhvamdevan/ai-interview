import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  late Box<UserModel> userBox;
  late Box<String> sessionBox;

  @override
  void onInit() {
    super.onInit();

    userBox = Hive.box<UserModel>('users');
    sessionBox = Hive.box<String>('session');

    _loadSession();
  }

  void _loadSession() {
    final savedEmail = sessionBox.get('currentEmail');

    if (savedEmail == null) return;

    final user = userBox.values.firstWhereOrNull((u) => u.email == savedEmail);

    if (user != null) {
      currentUser.value = user;
    } else {
      sessionBox.delete('currentEmail');
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  bool _validateInputs(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Invalid email format");
      return false;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return false;
    }

    return true;
  }

  void signupUser(String email, String password) {
    if (!_validateInputs(email, password)) return;

    final existingUser = userBox.values.firstWhereOrNull(
      (u) => u.email == email,
    );

    if (existingUser != null) {
      Get.snackbar("Error", "User already exists. Please log in.");
      return;
    }

    final newUser = UserModel(email: email, password: _hashPassword(password));

    userBox.add(newUser);
    currentUser.value = newUser;
    sessionBox.put('currentEmail', newUser.email);

    Get.snackbar("Success", "Account created successfully");
    Get.offAllNamed('/home');
  }

  void loginUser(String email, String password) {
    if (!_validateInputs(email, password)) return;

    final hashedPassword = _hashPassword(password);

    final user = userBox.values.firstWhereOrNull(
      (u) => u.email == email && u.password == hashedPassword,
    );

    if (user == null) {
      Get.snackbar("Error", "Invalid email or password");
      return;
    }

    currentUser.value = user;
    sessionBox.put('currentEmail', user.email);

    Get.snackbar("Success", "Welcome back ${user.email}");
    Get.offAllNamed('/home');
  }

  void logoutUser() {
    currentUser.value = null;
    sessionBox.delete('currentEmail');

    Get.snackbar("Logged Out", "You have been logged out");
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => currentUser.value != null;
}
