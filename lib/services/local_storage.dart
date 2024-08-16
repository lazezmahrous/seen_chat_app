import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<Map<String, dynamic>?> getCachedUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('cachedUserData');
    if (userDataJson != null) {
      Map<String, dynamic> data = jsonDecode(userDataJson);

      // تحويل كل قيم الـ String إلى DateTime لو كانت أصلاً Timestamp
      data = data.map((key, value) {
        if (value is String && DateTime.tryParse(value) != null) {
          return MapEntry(key, DateTime.parse(value));
        } else {
          return MapEntry(key, value);
        }
      });

      return data;
    }
    return null;
  }

  static Future<void> setHarfOfTranslate({required String harf}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('harfOfTranslate', harf);
  }

  static Future<String> getHarfOfTranslate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? harfOfTranslate = 'س';
    if (prefs.getString('harfOfTranslate') == null) {
      await setHarfOfTranslate(harf: 'س');
    } else {
      harfOfTranslate = prefs.getString('harfOfTranslate');
    }

    return harfOfTranslate!;
  }
}
