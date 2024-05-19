import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../utils/utils.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService =
      ApiService('https://sinergi-untuk-negeri.online');

  // ignore: use_key_in_widget_constructors
  LoginScreen({Key? key});

  Future<void> _navigateToHome(BuildContext context) async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Validasi input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      // Perform the login check directly
      final user = await _apiService.loginUser(email, password);

      if (user != null) {
        // Save user session using shared_preferences
        await _saveUserSession(user);

        // If login is successful, navigate to the home screen
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle unsuccessful login (show error message, etc.)
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      // Handle error, show error message, etc.
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: const Text(
              'Terjadi kesalahan saat login, pastikan email dan password benar.',
              style: TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveUserSession(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', user.id);
    prefs.setString('user_username', user.username);
    prefs.setString('user_email', user.email);
    prefs.setString('user_nomortelepon', user.nomortelepon);
    // Anda bisa menambahkan data tambahan sesuai kebutuhan
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Scene(
          emailController: _emailController,
          passwordController: _passwordController,
          navigateToHome: _navigateToHome,
          navigateToRegister: _navigateToRegister,
        ),
      ),
    );
  }
}

class Scene extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(BuildContext) navigateToHome;
  final Function(BuildContext) navigateToRegister;

  const Scene({super.key, 
    required this.emailController,
    required this.passwordController,
    required this.navigateToHome,
    required this.navigateToRegister,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SceneState createState() => _SceneState();
}

class _SceneState extends State<Scene> {
  bool _isObscured = true; // Deklarasi variabel _isObscured di sini
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 31 * fem),
            padding: EdgeInsets.fromLTRB(0 * fem, 44 * fem, 0 * fem, 75 * fem),
            width: 368 * fem,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, 0.875),
                colors: <Color>[Color(0xff21b573), Color(0x0021b573)],
                stops: <double>[0.491, 1],
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 361 * fem,
                height: 361 * fem,
                child: Image.asset(
                  'assets/images/sun.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 0 * fem),
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Content',
                fontSize: 22 * ffem,
                fontWeight: FontWeight.w700,
                height: 0.8375 * ffem / fem,
                color: const Color(0xff000000),
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.fromLTRB(29 * fem, 15 * fem, 28 * fem, 27 * fem),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                  padding:
                      EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 10 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffececec)),
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(6 * fem),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x3f000000),
                        offset: Offset(0 * fem, 4 * fem),
                        blurRadius: 2 * fem,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5 * fem),
                      TextField(
                        controller: widget
                            .emailController, // Menggunakan controller yang diberikan
                        decoration: InputDecoration(
                          hintText: ' E-mail',
                          hintStyle: TextStyle(
                            color: const Color(0xffb2b2b2),
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.8375 * ffem / fem,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10 * fem, horizontal: 16 * fem),
                        ),
                      ),
                      SizedBox(height: 6 * fem),
                      Container(
                        width: double.infinity,
                        height: 1 * fem,
                        decoration: const BoxDecoration(
                          color: Color(0xffececec),
                        ),
                      ),
                      SizedBox(height: 6 * fem),
                      SizedBox(height: 6 * fem),
                      TextField(
                        controller: widget.passwordController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: const Color(0xffb2b2b2),
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.8375 * ffem / fem,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10 * fem, horizontal: 16 * fem),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscured
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(92 * fem, 0 * fem, 0 * fem, 44 * fem),
                  child: TextButton(
                    onPressed: () {
                      widget.navigateToRegister(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 8 * fem, // Adjust the vertical padding
                        horizontal: 16 * fem, // Adjust the horizontal padding
                      ),
                    ),
                    child: Text(
                      'Belum Punya Akun? Registrasi',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Content',
                        fontSize: 10 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.8375 * ffem / fem,
                        color: const Color(0xff02244f),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff21b573),
                    borderRadius: BorderRadius.circular(5 * fem),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await widget.navigateToHome(context);
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Center(
                            child: Text(
                              'Masuk',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Content',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.8375 * ffem / fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
