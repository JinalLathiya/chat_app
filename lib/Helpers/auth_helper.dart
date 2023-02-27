import 'package:fb_chat_app/Utils/source.dart';

class HelperFunctions {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "LOGGEDINKEY";
  static String userEmailKey = "LOGGEDINKEY";

  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return await sF.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return await sF.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return await sF.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return sF.getBool(userLoggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return sF.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sF = await SharedPreferences.getInstance();

    return sF.getString(userEmailKey);
  }
}
