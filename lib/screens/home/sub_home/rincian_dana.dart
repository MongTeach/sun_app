import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/post_model.dart';

class RincianDana extends StatefulWidget {
  final Post post;

  const RincianDana({Key? key, required this.post}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RincianDanaState createState() => _RincianDanaState();
}

class _RincianDanaState extends State<RincianDana> {
  late int daysSinceCreation;

  int _calculateDaysSinceCreation(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays;
  }

  @override
  void initState() {
    super.initState();
    daysSinceCreation = _calculateDaysSinceCreation(widget.post.createdAt);
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
            'Rincian Penggunaan Dana',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(
                    16.0), // Tambahkan padding 16 pada bagian atas dan bawah
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.payment,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      // Menggunakan Flexible di sini
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status Dana Terkumpul",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8), // Spacer
                          Text(
                            // Menggunakan Text langsung tanpa Padding terpisah
                            "Penggalang dana sudah mengumpulkan dana selama ${_calculateDaysSinceCreation(widget.post.createdAt)} hari",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Dana terkumpul",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.post.funds_raised != null
                                  ? NumberFormat.currency(
                                          locale: 'id_ID', symbol: 'Rp')
                                      .format(double.parse(
                                          widget.post.funds_raised!))
                                  : '0',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 4),
                                Text(
                                  "Dana untuk penggalangan dana",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.post.funds_raised != null
                                  ? NumberFormat.currency(
                                          locale: 'id_ID', symbol: 'Rp')
                                      .format(double.parse(
                                          widget.post.funds_raised!))
                                  : '0',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 4),
                                Text(
                                  "Biaya transaksi dan teknologi*",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.post.funds_raised != null
                                  ? NumberFormat.currency(
                                          locale: 'id_ID', symbol: 'Rp')
                                      .format(double.parse(
                                              widget.post.funds_raised!) *
                                          0.95)
                                  : '0',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 4),
                                Text(
                                  "Sudah dicairkan*",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.post.is_penyaluran_dana == '0'
                                    ? Colors.orange
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.post.is_penyaluran_dana == '0'
                                    ? 'Belum dicairkan'
                                    : 'Berhasil dicairkan',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '5%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      // Menggunakan Flexible di sini
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Biaya operasional SUN",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8), // Spacer
                          Text(
                            widget.post.funds_raised != null
                                ? NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                  ).format(
                                    double.parse(widget.post.funds_raised!) *
                                        0.05,
                                  )
                                : '0',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8), // Spacer
                          const Text(
                            "Donasi untuk operasional SUN agar donasi semakin aman, mudah & transparan. Maksimal 5% dari donasi terkumpul, selengkapnya.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      // Menggunakan Flexible di sini
                      child: Container(
                        padding: const EdgeInsets.all(
                            8), // Tambahkan padding di sini
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors
                                  .grey), // Tambahkan border dengan warna abu-abu
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Tambahkan border radius jika diinginkan
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total target dan penggunaan donasi dapat berubah menyesuaikan kondisi dan kebutuhan selama galang dana berlangsung",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8), // Spacer
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
