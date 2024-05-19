import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/midtrans_transaction_model.dart';
import '../../../models/post_model.dart';
import 'DetailRiwayatScreen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late Future<List<MidtransTransaction>> _transactionFuture;
  late List<Post> donations = [];
  int _loadedItems = 6;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionFuture = fetchTransactions();
    fetchDonations();
  }

  Future<List<MidtransTransaction>> fetchTransactions() async {
    String? email = await fetchUserEmail();
    try {
      var response = await http.get(Uri.parse(
          'https://sinergi-untuk-negeri.online/app/api/api_transaksi.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<MidtransTransaction> transactions = data
            .map((transaction) => MidtransTransaction.fromJson(transaction))
            .where((transaction) => transaction.email == email)
            .toList();
        return transactions;
      } else {
        throw Exception(
            'Gagal mengambil data transaksi: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Terjadi kesalahan: $error');
    }
  }

  Future<void> fetchDonations() async {
    try {
      var response = await http.get(Uri.parse(
          'https://sinergi-untuk-negeri.online/app/api/api_donasi.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          // Penambahan pengecekan mounted di sini
          setState(() {
            donations =
                data.map((donation) => Post.fromJson(donation)).toList();
          });
        }
      } else {
        throw Exception(
            'Gagal mengambil data donasi: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<String?> fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  void loadMoreItems() {
    setState(() {
      _loadedItems += 6;
    });
  }

   @override
  void initState() {
    super.initState();
    _transactionFuture = fetchTransactions();
    fetchDonations();
  }

  Future<void> _refreshData() async {
    // Reset _transactionFuture dan fetch data transaksi baru
    setState(() {
      _transactionFuture = fetchTransactions();
    });
    // Fetch data donasi juga jika diperlukan
    fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,      
       child: FutureBuilder<List<MidtransTransaction>>(
        future: _transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Terjadi kesalahan.'),
            );
          } else {
            List<MidtransTransaction> transactions = snapshot.data!;
            DateFormat dateFormat = DateFormat.yMd().add_jm();
            NumberFormat currencyFormat =
                NumberFormat.currency(locale: 'en_US', symbol: '');

            return ListView.builder(
              itemCount: _loadedItems < transactions.length
                  ? _loadedItems + 1
                  : transactions.length,
              itemBuilder: (context, index) {
                if (index == _loadedItems) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: loadMoreItems,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 66, 190, 70),
                        ),
                      ),
                      child: const Text(
                        'Lihat lainya',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                      ),
                    ),
                  );
                }
                if (index < transactions.length) {
                  MidtransTransaction transaction =
                      transactions.reversed.toList()[index];

                  Post? donation = donations.firstWhere(
                    (donation) => donation.id == transaction.postId,
                    orElse: () => Post(
                      id: '',
                      title: '',
                      content: '',
                      imageUrl: '',
                      category: '',
                      penyelenggara: '',
                      createdAt: DateTime.now(),
                      updatedAt: '',
                      target_funds: '',
                      is_penyaluran_dana: '',
                      expired_at: DateTime.now(),
                    ),
                  );

                  String statusText =
                      transaction.transactionStatus == 'settlement'
                          ? 'Berhasil'
                          : 'Tertunda';

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRiwayatScreen(
                              donation: donation, transaction: transaction),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Sesuaikan sudut bulat sesuai kebutuhan
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://sinergi-untuk-negeri.online/campaign/images/${donation.imageUrl}',
                              width:
                                  100, // Sesuaikan lebar gambar sesuai kebutuhan
                              height:
                                  100, // Sesuaikan tinggi gambar sesuai kebutuhan
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            donation.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${dateFormat.format(DateTime.parse(transaction.transactionTime))} - ${currencyFormat.format(transaction.grossAmount)} ($statusText)',
                            style: transaction.transactionStatus == 'settlement'
                                ? const TextStyle(color: Colors.green)
                                : const TextStyle(color: Colors.red),
                          ),
                          subtitleTextStyle:
                              const TextStyle(color: Colors.black),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        Container(
                          height: 5, // Tinggi kotak pemisah
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 224, 224, 224), // Warna kotak pemisah
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 224, 224, 224)
                                    .withOpacity(0.1), // Warna bayangan
                                spreadRadius: 1, // Jarak penyebaran bayangan
                                blurRadius: 1, // Tingkat keburaman bayangan
                                offset: const Offset(0,
                                    1), // Posisi bayangan relatif terhadap konten
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            );
          }
        },
      ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6, // Jumlah item shimmer yang ingin ditampilkan
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
                title: Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
