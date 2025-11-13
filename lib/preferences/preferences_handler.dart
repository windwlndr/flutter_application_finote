import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String keyId = 'keyId';
  static const String keyUsername = 'keyUsername';
  static const String keyEmail = 'keyEmail';

  //Save data login pada saat login
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  static Future<void> saveUserData(int id, String usn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyId, id);
    await prefs.setString(keyUsername, usn);

    // print('✅ User data saved: id=$id, username=$usn');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? usn = prefs.getString(keyUsername);
    // print('📦 Retrieved username: $usn');
    return usn;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyId);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  //Hapus data login pada saat logout
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLogin);
    await prefs.remove(keyEmail);
  }
}
