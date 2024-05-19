import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/sub_home/BencanaAlam_category.dart';
import 'screens/auth/login_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/message/messages_screen.dart';
import 'widgets/bottom_navigation_bar.dart';
// ignore: unused_import
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String?> _getUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            if (kDebugMode) {
              print('User email: ${snapshot.data}');
            }
            return MaterialApp(
              title: 'SUN',
              initialRoute: '/home',
              routes: {
                '/home': (context) => const MyHomePage(),
                '/account': (context) => const AccountScreen(),
                '/login': (context) => LoginScreen(),
                '/message': (context) => const MessagesScreen(),
                '/bencana_alam': (context) => const BencanaAlamCategory(),
              },

              debugShowCheckedModeBanner:
                  false, // Tambahkan ini untuk menghapus tulisan debug
            );
          } else {
            return MaterialApp(
              title: 'SUN',
              initialRoute: '/login',
              routes: {
                '/home': (context) => const MyHomePage(),
                '/account': (context) => const AccountScreen(),
                '/login': (context) => LoginScreen(),
                '/message': (context) => const MessagesScreen(),
                '/bencana_alam': (context) => const BencanaAlamCategory(),
              },
              debugShowCheckedModeBanner:
                  false, // Tambahkan ini untuk menghapus tulisan debug
            );
          }
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const MessagesScreen(),
    const HomeScreen(),
    const AccountScreen(),
  ];
}
