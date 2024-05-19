import 'package:flutter/material.dart';
import '../../widgets/message_widget.dart';
import 'sub-message/riwayat_screen.dart'; // Sesuaikan dengan lokasi RiwayatScreen

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _currentIndex = 0;

  // Fungsi untuk mengubah warna ikon berdasarkan nilai _currentIndex
  Color _getIconColor(int index) {
    return index == _currentIndex ? Colors.green : Colors.grey; // Ubah warna ikon berdasarkan _currentIndex
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Text(
            'Donasi Saya',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == 0 ? Colors.green : Colors.transparent, // Tentukan warna border berdasarkan _currentIndex
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Ubah sesuai kebutuhan
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.history, size: 32),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0; // Atur indeks ke 0 untuk menampilkan riwayat
                        });
                      },
                      color: _getIconColor(0), // Ubah warna ikon berdasarkan _currentIndex
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == 1 ? Colors.green : Colors.transparent, // Tentukan warna border berdasarkan _currentIndex
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Ubah sesuai kebutuhan
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.message, size: 32),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1; // Atur indeks ke 1 untuk menampilkan pesan
                        });
                      },
                      color: _getIconColor(1), // Ubah warna ikon berdasarkan _currentIndex
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: const [
                RiwayatScreen(), // Menggunakan RiwayatScreen di sini
                MessageWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
