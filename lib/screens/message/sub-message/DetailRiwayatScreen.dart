// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import '../../../models/midtrans_transaction_model.dart';
import 'package:intl/intl.dart'; 

class DetailRiwayatScreen extends StatelessWidget {
  final Post donation;
  final MidtransTransaction transaction;

  const DetailRiwayatScreen({Key? key, required this.donation, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format mata uang untuk grossAmount
    final grossAmountFormatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transaction.grossAmount);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          // tombol back:
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Detail Donasi',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDataRow('Tanggal', transaction.transactionTime, Icons.calendar_today),
              buildDataRow('Metode Pembayaran', transaction.paymentType, Icons.payment),
              buildDataRow('ID Donasi', transaction.orderId, Icons.confirmation_number),
              buildDataRow('Status', _getStatusText(transaction.transactionStatus), Icons.info),
              buildDataRow('Judul', donation.title, Icons.title),
              buildDataRow('Jumlah Donasi', grossAmountFormatted, Icons.monetization_on), // Menggunakan grossAmountFormatted
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Tambahkan fungsi untuk menampilkan menu bantuan
            },
            icon: const Icon(Icons.help, color: Colors.white),
            label: const Text(
              'Bantuan',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataRow(String label, String value, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 24,
            color: Colors.black87,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'settlement':
        return 'Berhasil';
      case 'pending':
        return 'Tertunda';
      default:
        return status;
    }
  }
}
