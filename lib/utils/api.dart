import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';
import '../models/post_model.dart';

// Fungsi untuk mengambil data post dari API
class ApiPost {
  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://sinergi-untuk-negeri.online/app/api/api_donasi.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 5)); // Timeout set to 5 seconds

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Post.fromJson(model)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

class ApiComment {
  static Future<List<Comment>> fetchcomment() async {
    try {
      final response = await http.read(
        Uri.parse('https://sinergi-untuk-negeri.online/app/api/api_comments.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 5)); // Timeout set to 5 seconds

      Iterable list = json.decode(response);
      return list.map((model) => Comment.fromJson(model)).toList();
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}


