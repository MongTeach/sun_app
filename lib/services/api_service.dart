import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/midtrans_transaction_model.dart';
import '../models/user.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/app/login.php'),
        body: {'email': email, 'password': password},
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> data = json.decode(response.body);
          if (data['success'] == true) {
            return User.fromJson(data['user']);
          } else {
            throw Exception(data['message']);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding JSON: $e');
          }
          throw Exception('Failed to parse JSON response');
        }
      } else {
        throw Exception('Failed to login: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to login: $e');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/app/check_email.php'),
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception('Failed to check email existence. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check email existence: $e');
    }
  }

  Future<void> registerUser(String username, String email, String nomortelepon,
      String password) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/app/register.php'), // Convert the string URL to Uri object
      body: {
        'username': username,
        'email': email,
        'nomortelepon': nomortelepon,
        'password': password
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/app/api/api_donasi.php'));
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<List<MidtransTransaction>> fetchTransactions(int postId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/app/api/api_transaksi.php'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<MidtransTransaction> transactions =
            jsonData.map((json) => MidtransTransaction.fromJson(json)).toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  Future<List<Comment>> fetchComments() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/app/api/api_comments.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<Comment> comments =
            jsonData.map((json) => Comment.fromJson(json)).toList();
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }
}
