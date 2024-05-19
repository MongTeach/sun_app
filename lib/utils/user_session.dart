// fungsi untuk mendapatkan session user yang sedang login

// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email');
}
