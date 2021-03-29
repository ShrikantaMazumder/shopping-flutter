import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get getUserId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _userId != null &&
        _expiryTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  /// Signup
  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCh5YiqCvnOTz4_QGteABtE1qt6z2iFhjQ";
    final response = await http.post(url,
        body: jsonEncode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));
    final responseData = jsonDecode(response.body);
    if (responseData["error"] != null) {
      throw HttpException(responseData["error"]["message"]);
    }
    _token = responseData["idToken"];
    _expiryTime = DateTime.now()
        .add(Duration(seconds: int.parse(responseData["expiresIn"])));
    _userId = responseData["localId"];
    autoLogOut();
    notifyListeners();

    /// Shared Preferences
    /// Save userData to local device
    final PrefManager = await SharedPreferences.getInstance();
    final userData = jsonEncode({
      "token": _token,
      "userId": _userId,
      "expiryTime": _expiryTime.toIso8601String()
    });
    PrefManager.setString("userData", userData);
  }

  /// Sign in
  Future<void> signIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCh5YiqCvnOTz4_QGteABtE1qt6z2iFhjQ";

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _expiryTime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _userId = responseData["localId"];
      autoLogOut();
      notifyListeners();

      /// Shared Preferences
      /// Save userData to local device
      final PrefManager = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        "token": _token,
        "userId": _userId,
        "expiryTime": _expiryTime.toIso8601String()
      });
      PrefManager.setString("userData", userData);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  /// Try auto login
  Future<bool> tryAutoLogIn() async {
    final PrefManager = await SharedPreferences.getInstance();
    if (!PrefManager.containsKey("userData")) {
      return false;
    }
    final extractedData = jsonDecode(PrefManager.getString("userData"));
    final expiryTime = DateTime.parse(extractedData["expiryTime"]);

    if (expiryTime.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData["token"];
    _userId = extractedData["userId"];
    _expiryTime = expiryTime;
    notifyListeners();
    autoLogOut();
    return true;
  }

  /// logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();
    final PrefManager = await SharedPreferences.getInstance();

    /// clear specific data from shared_preferences
    PrefManager.remove("userData");

    /// Clear all data from shared_preferences
    /// PrefManager.clear()
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _timeToExpire = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToExpire), logout);
  }
}
