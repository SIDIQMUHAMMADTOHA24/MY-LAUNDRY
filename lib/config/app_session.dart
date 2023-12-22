import 'dart:convert';

import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  static Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString(AppConstant.user);
    if (userString == null) return null;

    var userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }

  static Future<bool> setUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString(AppConstant.user, userString);
    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove(AppConstant.user);
    return success;
  }

  static Future<String?> getBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString(AppConstant.bearerToken);
    return token;
  }

  static Future<bool> setBearerToken(String beareToken) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString(AppConstant.bearerToken, beareToken);
    return success;
  }

  static Future<bool> removeBearerToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove(AppConstant.bearerToken);
    return success;
  }
}
