import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/midtrans_transaction_model.dart'; // Import model MidtransTransaction

class DetailRiwayatDonasi extends StatefulWidget {
  final List<MidtransTransaction> transactions;

  const DetailRiwayatDonasi({Key? key, required this.transactions})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailRiwayatDonasiState createState() => _DetailRiwayatDonasiState();
}

class _DetailRiwayatDonasiState extends State<DetailRiwayatDonasi> {
  int _visibleTransactionCount = 10;

  void _loadMoreTransactions() {
    setState(() {
      _visibleTransactionCount += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'Detail Riwayat Donasi',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF21B573), Color(0x0021B573)],
                begin: Alignment.topCenter,
                end: Alignment(
                    0, 0.5), // Sesuaikan dengan alignment yang Anda inginkan
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(8.0), // Atur padding sesuai kebutuhan Anda
        child: ListView.builder(
          itemCount: _visibleTransactionCount < widget.transactions.length
              ? _visibleTransactionCount
              : widget.transactions.length,
          itemBuilder: (context, index) {
            var transaction = widget.transactions[index];
            var emailParts = transaction.email.split('@');
            var username = emailParts[0];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
              color: Colors.white,
              elevation: 1, // Menambahkan bayangan ke card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Mengatur sudut card
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.black, // Mengatur warna ikon person
                    ),
                    title: Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[300], // Warna pembatas
                    height: 1, // Tinggi pembatas
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 8,
                        ), // Spacer untuk menambahkan jarak
                        Text(
                          'Berdonasi Sebesar: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transaction.grossAmount)} ${transaction.currency},',
                          style: const TextStyle(
                            fontSize: 12, // Mengatur ukuran font tanggal
                            color: Colors.grey, // Mengatur warna teks tanggal
                          ),
                        ),
                        Text(
                          'Tanggal: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(transaction.transactionTime))}',
                          style: const TextStyle(
                            fontSize: 12, // Mengatur ukuran font tanggal
                            color: Colors.grey, // Mengatur warna teks tanggal
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _visibleTransactionCount < widget.transactions.length
          ? ElevatedButton(
              onPressed: _loadMoreTransactions,
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 66, 190, 70),
                ),
              ),
              child: const Text(
                'Lihat Lainya',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0),
              ),
            )
          : null,
    );
  }
}
