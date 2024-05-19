// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/midtrans_transaction_model.dart';
import '../../../models/post_model.dart';
import '../../../models/comment_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/donasi.dart';
import 'detail_riwayat_donasi.dart';
import 'detail_riwayat_komentar.dart';
import 'rincian_dana.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<List<MidtransTransaction>> _transactionFuture;
  late Future<List<Comment>> _commentFuture;
  late String _appBarTitle;

  bool _isExpanded = false;

  // Fungsi untuk fetch data
  void _fetchData() {
    _transactionFuture = fetchTransactions();
    _commentFuture = fetchComments();
    _appBarTitle = widget.post.title;
  }

  // Fungsi untuk refresh data
  Future<void> _refreshData() async {
    setState(() {
      _transactionFuture = fetchTransactions();
      _commentFuture = fetchComments();
      _appBarTitle = widget.post.title;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Function to update the app bar title
  void updateAppBarTitle(String newTitle) {
    setState(() {
      _appBarTitle = newTitle;
    });
  }

  Future<List<MidtransTransaction>> fetchTransactions() async {
    var response = await http.get(Uri.parse(
        'https://sinergi-untuk-negeri.online/app/api/api_transaksi.php'));
    Iterable list = json.decode(response.body);
    List<MidtransTransaction> transactions =
        list.map((model) => MidtransTransaction.fromJson(model)).toList();
    transactions = transactions
        .where((transaction) =>
            transaction.postId == widget.post.id &&
            transaction.transactionStatus == "settlement")
        .toList();
    return transactions;
  }

  Future<List<Comment>> fetchComments() async {
    try {
      // Mengambil data komentar dari ApiService dengan baseUrl yang diperlukan
      List<Comment> allComments =
          await ApiService('https://sinergi-untuk-negeri.online')
              .fetchComments();

      // Memfilter komentar berdasarkan postId dari widget
      List<Comment> filteredComments = allComments
          .where((comment) => comment.postId == widget.post.id)
          .toList();

      return filteredComments;
    } catch (e) {
      // Handle error jika terjadi
      throw Exception('Failed to fetch comments: $e');
    }
  }

// Calculate percentage of funds raised
  double calculatePercentageRaised() {
    double target = double.parse(widget.post.target_funds);
    double raised = widget.post.funds_raised != null
        ? double.parse(widget.post.funds_raised!)
        : 0.0;
    return (raised / target) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double percentageRaised = calculatePercentageRaised();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Adjust as needed
        child: AppBar(
          // tombol back:
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            _appBarTitle,
            style: const TextStyle(color: Colors.white),
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  // Menggunakan CachedNetworkImage
                  imageUrl:
                      'https://sinergi-untuk-negeri.online/campaign/images/${widget.post.imageUrl}',
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(), // Placeholder saat gambar sedang dimuat
                  errorWidget: (context, url, error) => const Icon(Icons
                      .error), // Widget untuk menampilkan jika terjadi error saat memuat gambar
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // fontFamily: 'Poppins',
                          // color: Color(0xFF21B573),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            widget.post.penyelenggara,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 12,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Terkumpul ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.post.funds_raised != null
                                    ? NumberFormat.currency(
                                            locale: 'id_ID', symbol: 'Rp')
                                        .format(double.parse(
                                            widget.post.funds_raised!))
                                    : '0',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'Poppins',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          // LinearProgressIndicator untuk bagian yang telah terisi
                          LinearProgressIndicator(
                            value: percentageRaised / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                            minHeight: 8,
                          ),
                          // LinearProgressIndicator untuk bagian yang belum terisi
                          LinearProgressIndicator(
                            value:
                                1.0, // Jika value == 1.0, seluruh bar belum terisi
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green.withOpacity(
                                  0.3), // Warna hijau dengan opacity rendah
                            ),
                            minHeight: 8,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Target ',
                              style: TextStyle(
                                color: Colors.grey, // Warna untuk "Terkumpul"
                              ),
                            ),
                            TextSpan(
                              text: NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                              ).format(double.parse(widget.post.target_funds)),
                              style: const TextStyle(
                                color: Colors
                                    .green, // Warna untuk widget.post.target_funds
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Informasi Penggalangan Dana",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Lebar kontainer sesuai dengan lebar layar
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Penggalang Dana",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8), // Spacer
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.post.penyelenggara,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Lebar kontainer sesuai dengan lebar layar
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RincianDana(post: widget.post),
                                    ),
                                  );
                                },
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8), // Spacer
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.payment,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Rincian Penggunaan Dana",
                                          style: TextStyle(
                                            fontSize: 14,
                                            
                                            // color: Colors.grey,
                                          ),
                                        ),
                                        Spacer(), // Memberikan ruang kosong di antara teks dan ikon
                                        Icon(
                                          FontAwesomeIcons.angleRight,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
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

                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Color(0xFF21B573),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Color(0xFF21B573),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _isExpanded
                                  ? widget.post.content
                                  : truncateContent(widget.post.content),
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21B573),
                        ),
                        child: Text(
                          _isExpanded ? 'Sembunyikan' : 'Selengkapnya',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                FutureBuilder<List<MidtransTransaction>>(
                  future: _transactionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRiwayatDonasi(
                                    transactions: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text('Donasi:'),
                                SizedBox(width: 8),
                                Text(
                                    'Loading transaksi...'), // Menampilkan loading text
                              ],
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  5, // Jumlah placeholder yang ingin ditampilkan
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Tidak ada donasi');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRiwayatDonasi(
                                    transactions: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Donasi: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          snapshot.data!.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.angleRight,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length > 5
                                ? 5
                                : snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var transaction =
                                  snapshot.data!.reversed.toList()[index];
                              var emailParts = transaction.email.split('@');
                              var username = emailParts[0];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 2.0),
                                color: Colors.white,
                                elevation: 0, // Menambahkan bayangan ke card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Mengatur sudut card
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors
                                            .black, // Mengatur warna ikon person
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(
                                              height:
                                                  8), // Spacer untuk menambahkan jarak
                                          Text(
                                            'Berdonasi Sebesar: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transaction.grossAmount)} ${transaction.currency},',
                                            style: const TextStyle(
                                              fontSize:
                                                  12, // Mengatur ukuran font tanggal
                                              color: Colors
                                                  .grey, // Mengatur warna teks tanggal
                                            ),
                                          ),
                                          Text(
                                            'Tanggal: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(transaction.transactionTime))}',
                                            style: const TextStyle(
                                              fontSize:
                                                  12, // Mengatur ukuran font tanggal
                                              color: Colors
                                                  .grey, // Mengatur warna teks tanggal
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
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 16), // Spacer untuk menambahkan jarak
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
                const SizedBox(height: 16),
                FutureBuilder<List<Comment>>(
                  future: _commentFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRiwayatKomentar(
                                    komentar: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text('Komentar:'),
                                SizedBox(width: 8),
                                Text(
                                  'Loading komentar...', // Menampilkan loading text
                                ),
                              ],
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  5, // Jumlah placeholder yang ingin ditampilkan
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRiwayatKomentar(
                                    komentar: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Komentar: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          snapshot.data!.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.angleRight,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length > 5
                                ? 5
                                : snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var komentar =
                                  snapshot.data!.reversed.toList()[index];
                              var emailParts = komentar.email.split('@');
                              var username = emailParts[0];
                              String commentText = komentar.comment.length > 100
                                  ? '${komentar.comment.substring(0, 100)}...'
                                  : komentar.comment;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 2.0),
                                color: Colors.white,
                                elevation: 0, // Menambahkan bayangan ke card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Mengatur sudut card
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.black,
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
                                      color: const Color.fromARGB(
                                          255, 233, 233, 233),
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            commentText,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tanggal: ${DateFormat('dd MMMM yyyy').format(komentar.createdAt)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
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
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 16), // Spacer untuk menambahkan jarak
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
                const SizedBox(height: 16), // Spacer untuk menambahkan jarak
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DonationOptions(
                      post: widget.post, postId: widget.post.id);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21B573),
            ),
            child: const Text(
              'BERSINERGI',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  String truncateContent(String content) {
    return content.length <= 300 ? content : '${content.substring(0, 300)}...';
  }
}
