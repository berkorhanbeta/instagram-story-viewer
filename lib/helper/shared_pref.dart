import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  final String _key = 'userList';

  // Kullanıcıyı kaydet
  Future<bool> saveData(String name, String username, String photo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> userList = await getData();
    if(userList.any((v) => v['username'] == username)){
      return false;
    } else {
      userList.add({'name': name, 'username': username, 'photo': photo});
    }
    await prefs.setString(_key, jsonEncode(userList));
    return true;
  }

  Future<List<Map<String, String>>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_key);
    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }

  Future<void> delData(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> userList = await getData();
    userList.removeWhere((user) => user['username'] == username);
    await prefs.setString(_key, jsonEncode(userList));
  }

  Future<bool> checkUserImage(String username, String photo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> userList = await getData();
    final userIndex = userList.indexWhere((v) => v['username'] == username);
    if (userIndex != -1) {
      if (userList[userIndex]['photo'] != photo) {
        userList[userIndex]['photo'] = photo;
      }
      await prefs.setString(_key, jsonEncode(userList));
      return true;
    }
    return false;
  }

}
