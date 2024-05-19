// Di dalam setting_screen.dart
import 'package:flutter/material.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
      ),
      body: const Center(
        child: Text('Selamat datang di Pusat Bantuan'),
      ),
    );
  }
}
