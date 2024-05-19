import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sub_screens/galang_dana_screen.dart';
import 'sub_screens/profile_screen.dart';
import 'sub_screens/pengaturan_screen.dart';
import 'sub_screens/bantuan_screen.dart';
import 'sub_screens/tentang_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String username = '';
  bool isInternetAvailable = true;
  late ScaffoldMessengerState _scaffoldMessengerState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the ScaffoldMessengerState
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _checkInternetConnection();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user_username');
    setState(() {
      username = user ?? '';
    });
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PengaturanScreen()),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BantuanScreen()),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TentangScreen()),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear user data
    await prefs.clear();
    if (!context.mounted) return;
    _scaffoldMessengerState.hideCurrentSnackBar();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToGalangDana(BuildContext context) {
    // Function untuk navigasi ke layar Galang Dana
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GalangDanaScreen()),
    );
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isInternetAvailable = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _refresh() async {
    await _checkInternetConnection();
    if (isInternetAvailable) {
      await _getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 187, 186, 186),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Text(
            'Akun',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove elevation when scrolled
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF21B573), Color(0x0021B573)],
                begin: Alignment.topCenter,
                end: Alignment(0, 0.5), // Adjust the end alignment
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/sun.png',
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToProfile(context);
                      },
                      child: const IconButton(
                        icon: Icon(Icons.account_circle, size: 40.0),
                        onPressed: null,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        _navigateToProfile(context);
                      },
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isInternetAvailable)
                const Center(child: Text('Tidak ada koneksi internet.')),
              // Add the menu items
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Galang Dana'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToGalangDana(context);
                },
              ),
              Container(
                height: 10, // Tinggi kotak pemisah
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 224, 224, 224), // Warna kotak pemisah
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 224, 224, 224)
                          .withOpacity(0.1), // Warna bayangan
                      spreadRadius: 1, // Jarak penyebaran bayangan
                      blurRadius: 1, // Tingkat keburaman bayangan
                      offset: const Offset(
                          0, 1), // Posisi bayangan relatif terhadap konten
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Pengaturan'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToSettings(context);
                },
              ),
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Bantuan'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToHelp(context);
                },
              ),
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang SUN'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToAbout(context);
                },
              ),
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
              ListTile(
                leading: const Icon(Icons.document_scanner),
                title: const Text('Akuntanbilitas dan Transparansi'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToAbout(context);
                },
              ),
              Container(
                height: 10, // Tinggi kotak pemisah
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 224, 224, 224), // Warna kotak pemisah
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 224, 224, 224)
                          .withOpacity(0.1), // Warna bayangan
                      spreadRadius: 1, // Jarak penyebaran bayangan
                      blurRadius: 1, // Tingkat keburaman bayangan
                      offset: const Offset(
                          0, 1), // Posisi bayangan relatif terhadap konten
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Beri rating aplikasi SUN'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _navigateToAbout(context);
                },
              ),
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Keluar'),
                tileColor: Colors.white,
                selectedTileColor: Colors.white,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Show confirmation dialog before logout
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              _logout(context); // Perform logout
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider(
                color: Colors.grey, // Warna abu-abu
                height: 0, // Ketebalan garis
              ),
            ],
          ),
        ),
      ),
    );
  }
}
