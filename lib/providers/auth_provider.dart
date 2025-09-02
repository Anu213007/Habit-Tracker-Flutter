import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();
    await checkAuthState();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool('rememberMe') ?? true;
    final String? userDataString = rememberMe ? prefs.getString('currentUser') : null;

    if (userDataString != null) {
      try {
        final Map<String, dynamic> userMap = json.decode(userDataString);
        _user = UserModel.fromMap(userMap);
        _isAuthenticated = true;
        print('✅ User loaded from local storage: ${_user?.displayName}');
      } catch (e) {
        print('❌ Error parsing saved user data: $e');
        await prefs.remove('currentUser');
        _user = null;
        _isAuthenticated = false;
      }
      notifyListeners();
    } else {
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String displayName,
    required String email,
    required String password,
    String? gender,
    String? dateOfBirth,
    String? height,
  }) async {
    try {
      print('🚀 Starting LOCAL registration for: $email');
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final String? allUsersString = prefs.getString('allUsers');
      Map<String, dynamic> allUsers = {};
      if (allUsersString != null) {
        allUsers = Map<String, dynamic>.from(json.decode(allUsersString));
      }

      if (allUsers.containsKey(email)) throw Exception('email-already-in-use');

      final String userId = DateTime.now().millisecondsSinceEpoch.toString();
      final newUser = UserModel(
        id: userId,
        displayName: displayName,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
        height: height,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      allUsers[email] = newUser.toMap();
      await prefs.setString('allUsers', json.encode(allUsers));

      final userPasswords = Map<String, String>.from(json.decode(prefs.getString('userPasswords') ?? '{}'));
      userPasswords[email] = password;
      await prefs.setString('userPasswords', json.encode(userPasswords));

      await prefs.setString('currentUser', json.encode(newUser.toMap()));
      _user = newUser;
      _isAuthenticated = true;

      Fluttertoast.showToast(
        msg: 'Welcome to Habit Tracker! 🌸',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      return true;
    } catch (e) {
      print('❌ Registration error: $e');

      String errorMessage = 'Registration failed';
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Email is already registered';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      print('🚀 Attempting LOCAL login for: $email');
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final String? allUsersString = prefs.getString('allUsers');
      if (allUsersString == null) throw Exception('user-not-found');

      final Map<String, dynamic> allUsers = Map<String, dynamic>.from(json.decode(allUsersString));
      if (!allUsers.containsKey(email)) throw Exception('user-not-found');

      final userPasswords = Map<String, String>.from(json.decode(prefs.getString('userPasswords') ?? '{}'));
      if (userPasswords[email] != password) throw Exception('wrong-password');

      final userMap = Map<String, dynamic>.from(allUsers[email]);
      _user = UserModel.fromMap(userMap);
      _isAuthenticated = true;

      _user = _user!.copyWith(lastLoginAt: DateTime.now());
      allUsers[email] = _user!.toMap();
      await prefs.setString('allUsers', json.encode(allUsers));

      await prefs.setBool('rememberMe', rememberMe);
      if (rememberMe) {
        await prefs.setString('currentUser', json.encode(_user!.toMap()));
      } else {
        await prefs.remove('currentUser');
      }

      Fluttertoast.showToast(
        msg: 'Welcome back ${_user?.displayName}! 🌸',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      return true;
    } catch (e) {
      print('❌ Login error: $e');

      String errorMessage = 'Login failed';
      if (e.toString().contains('user-not-found')) errorMessage = 'No account found with this email';
      else if (e.toString().contains('wrong-password')) errorMessage = 'Incorrect password';

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      _user = null;
      _isAuthenticated = false;

      Fluttertoast.showToast(
        msg: 'See you soon! 🌸',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error during logout: $e');
    }
    notifyListeners();
  }

  Future<void> updateProfile({String? displayName, String? gender, String? dateOfBirth, String? height}) async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      _user = _user!.copyWith(
        displayName: displayName ?? _user!.displayName,
        gender: gender ?? _user!.gender,
        dateOfBirth: dateOfBirth ?? _user!.dateOfBirth,
        height: height ?? _user!.height,
      );

      final String? allUsersString = prefs.getString('allUsers');
      if (allUsersString != null) {
        final Map<String, dynamic> allUsers = Map<String, dynamic>.from(json.decode(allUsersString));
        allUsers[_user!.email] = _user!.toMap();
        await prefs.setString('allUsers', json.encode(allUsers));
      }

      await prefs.setString('currentUser', json.encode(_user!.toMap()));

      Fluttertoast.showToast(
        msg: 'Profile updated successfully! ✨',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update profile',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    notifyListeners();
  }
}
