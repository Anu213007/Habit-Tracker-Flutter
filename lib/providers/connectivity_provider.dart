import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isChecking = false;

  bool get isOnline => _isOnline;
  bool get isChecking => _isChecking;

  ConnectivityProvider() {
    _initConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _initConnectivity() async {
    _isChecking = true;
    notifyListeners();

    try {
      // Fixed: Use 'checkConnectivity()' instead of non-existent 'checkConnectivityStatus()'
      final connectivityResult = await Connectivity().checkConnectivity();
      _isOnline = connectivityResult != ConnectivityResult.none;
    } catch (e) {
      _isOnline = false;
    }

    _isChecking = false;
    notifyListeners();
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    });
  }

  Future<void> checkConnectivity() async {
    await _initConnectivity();
  }
}
