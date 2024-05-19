// Di dalam setting_screen.dart
import 'package:flutter/material.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: const Center(
        child: Text('Selamat datang di Tentang SUN'),
      ),
    );
  }
}
