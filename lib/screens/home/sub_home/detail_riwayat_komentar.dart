import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/comment_model.dart'; // Import model Comment

class DetailRiwayatKomentar extends StatefulWidget {
  final List<Comment> komentar;

  const DetailRiwayatKomentar({Key? key, required this.komentar})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailRiwayatKomentarState createState() => _DetailRiwayatKomentarState();
}

class _DetailRiwayatKomentarState extends State<DetailRiwayatKomentar> {
  int _visibleCommentCount = 10;

  void _loadMoreComments() {
    setState(() {
      _visibleCommentCount += 10;
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
            'Detail Riwayat Komentar',
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
          itemCount: _visibleCommentCount < widget.komentar.length
              ? _visibleCommentCount
              : widget.komentar.length,
          itemBuilder: (context, index) {
            var data_komentar = widget.komentar[index];
            var emailParts = data_komentar.email.split('@');
            var username = emailParts[0];
            String commentText = data_komentar.comment.length > 100
                ? '${data_komentar.comment.substring(0, 100)}...' // Memotong string jika lebih dari 100 karakter
                : data_komentar.comment;
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
                        Text(
                          commentText,
                          style: const TextStyle(
                            fontSize: 14, // Mengubah ukuran font komentar
                            color: Colors.grey, // Mengubah warna teks komentar
                          ),
                        ),
                        const SizedBox(
                            height: 8), // Spacer untuk menambahkan jarak
                        Text(
                          'Tanggal: ${DateFormat('dd MMMM yyyy').format(data_komentar.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12, // Mengatur ukuran font tanggal
                            color: Colors.grey, // Mengatur warna teks tanggal
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _visibleCommentCount < widget.komentar.length
          ? ElevatedButton(
              onPressed: _loadMoreComments,
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
