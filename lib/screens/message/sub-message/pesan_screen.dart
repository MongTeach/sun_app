// Di dalam setting_screen.dart
import 'package:flutter/material.dart';

class PesanScreen extends StatelessWidget {
  const PesanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Masuk'),
      ),
      body: const Center(
        child: Text('Selamat datang di Pesan Masuk'),
      ),
    );
  }
}
