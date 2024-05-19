import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/galang_dana_model.dart';

class GalangDanaScreen extends StatefulWidget {
  const GalangDanaScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GalangDanaScreenState createState() => _GalangDanaScreenState();
}

class _GalangDanaScreenState extends State<GalangDanaScreen> {
  Future<void> _launchURL() async {
    const url = 'https://sinergi-untuk-negeri.online/campaign/';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  late Future<List<GalangDanaUser>> _galangDanaFuture; // Deklarasi Future
  late ScaffoldMessengerState _scaffoldMessengerState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the ScaffoldMessengerState
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  // Fungsi untuk mengambil data galang dana dari API dan menyaring berdasarkan id_user
  Future<List<GalangDanaUser>> _fetchGalangDanaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final response = await http.get(Uri.parse('https://sinergi-untuk-negeri.online/app/api/galang_dana_api.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<GalangDanaUser> galangDanaData = responseData
          .where((data) => data['id_user'] == userId)
          .map((data) => GalangDanaUser.fromJson(data))
          .toList();
      return galangDanaData;
    } else {
      throw Exception('Gagal memuat data galang dana');
    }
  }

  // Fungsi untuk mereset FutureBuilder dan melakukan refresh data
  Future<void> _refreshData() async {
    setState(() {
      _galangDanaFuture = _fetchGalangDanaData();
    });
  }

  void _deleteGalangDana(String galangDanaId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://sinergi-untuk-negeri.online/app/delete_galang_dana.php'),
        body: {
          'galang_dana_id': galangDanaId,
        },
      );
      if (response.statusCode == 200) {
        // Jika penghapusan berhasil, Anda dapat memperbarui tampilan atau mengambil ulang data galang dana
        if (kDebugMode) {
          print(response.statusCode);
        }
        if (kDebugMode) {
          print('Menghapus galang dana dengan ID: $galangDanaId');
        }
        _refreshData();
      } else {
        // Jika penghapusan gagal, ambil pesan dari respons JSON
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['message'];
        // Tampilkan pesan kesalahan
        _scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting galang dana: $error');
      }
      // Tampilkan pesan kesalahan umum jika terjadi kesalahan yang tidak terduga
      _scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat menghapus galang dana.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _galangDanaFuture = _fetchGalangDanaData(); // Assign Future saat initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Galang Dana',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove elevation when scrolled
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF21B573), Color(0x0021B573)],
                begin: Alignment.topCenter,
                end: Alignment(0, 0.5),
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
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Kelola galang dana',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Spacer
                GestureDetector(
                  onTap: _launchURL,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 64,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Buat Galang Dana+',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 224, 224, 224)
                            .withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Daftar Galang Dana:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FutureBuilder<List<GalangDanaUser>>(
                  future: _galangDanaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      String errorMessage = 'Terjadi kesalahan.';
                      if (snapshot.error is SocketException) {
                        errorMessage = 'Tidak ada koneksi internet.';
                      }
                      return Center(child: Text(errorMessage));
                    } else {
                      List<GalangDanaUser>? galangDanaData = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                16), // Tambahkan padding horizontal di sini
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: galangDanaData!.length,
                          itemBuilder: (context, index) {
                            final galangDana = galangDanaData[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            'https://sinergi-untuk-negeri.online/campaign/images/${galangDana.gambar}',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                galangDana.judul,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  galangDana.status,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: galangDana.status ==
                                                            'disetujui'
                                                        ? Colors.green
                                                        : galangDana.status ==
                                                                'diproses'
                                                            ? Colors.orange
                                                            : Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (galangDana.status == 'ditolak') ...[
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              // Tambahkan fungsi delete di sini
                                              _deleteGalangDana(galangDana.id);
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (galangDana.status == 'disetujui') ...[
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Galang dana Anda telah disetujui.',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                    if (galangDana.status == 'diproses') ...[
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Galang dana Anda sedang diproses.',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ],
                                    if (galangDana.status == 'ditolak') ...[
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Galang dana tidak sesuai Community Guideline (Panduan Menggalang Dana) SUN',
                                              style:
                                                  TextStyle(color: Colors.red),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          // Tambahkan aksi untuk menghubungi layanan pengguna Kitabisa
                                        },
                                        child: const Text(
                                          'Hubungi Layanan Pengguna SUN',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (galangDana.status == 'diproses') ...[
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          // Tambahkan aksi untuk menghubungi layanan pengguna Kitabisa
                                        },
                                        child: const Text(
                                          'Hubungi Layanan Pengguna SUN',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
