import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import '../../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorponselController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService =
      ApiService('https://sinergi-untuk-negeri.online');

  bool _isLoading = false;
  bool _obscurePassword = true;

  late ScaffoldMessengerState _scaffoldMessengerState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the ScaffoldMessengerState
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _register(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String nomortelepon = _nomorponselController.text.trim();
      String password = _passwordController.text.trim();

      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          nomortelepon.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All fields are required.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!EmailValidator.validate(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid email address.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 8 characters long.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      bool emailExists = await _apiService.checkEmailExists(email);
      if (emailExists) {
        _scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text('Email already registered.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _apiService.registerUser(username, email, nomortelepon, password);
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');

      _scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text('Registration successful'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }

      _scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please check your details.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
          decoration: const BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem,
                    16 * fem), // Mengurangi jarak dengan textfield
                width: double.infinity,
                height: 480 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 360 * fem,
                          height: 480 * fem,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 0.875),
                                colors: <Color>[
                                  Color(0xff21b573),
                                  Color(0x0021b573)
                                ],
                                stops: <double>[0.491, 1],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0 * fem,
                      top: 25 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 371 * fem,
                          height: 371 * fem,
                          child: Image.asset(
                            'assets/images/sun.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 133.5 * fem,
                      top: 428 * fem,
                      child: Align(
                        child: SizedBox(
                          height: 41 * fem, // Tetapkan tinggi sesuai kebutuhan
                          child: Text(
                            'Registrasi',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Content',
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26 * fem),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomorponselController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 50 * fem, // Mengurangi tinggi tombol
                margin:
                    EdgeInsets.fromLTRB(26 * fem, 0 * fem, 22 * fem, 0 * fem),
                // Margin tambahan untuk penyesuaian
                decoration: BoxDecoration(
                  color: const Color(0xff3fbc79), // Warna latar belakang
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // Add some delay for better user experience
                          await Future.delayed(const Duration(seconds: 1));
                          if (!context.mounted) return;
                          await _register(context);
                        },
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ) // Show loading indicator when isLoading is true
                        : Text(
                            'Daftar',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Content',
                              fontSize: 15 * ffem, // Mengurangi ukuran font
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
      ),
    );
  }
}
