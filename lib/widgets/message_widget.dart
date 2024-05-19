import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ini Halaman Pesan',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
