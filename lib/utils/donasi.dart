import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class DonationOptions extends StatefulWidget {
  final Post post;
  final String postId;

  const DonationOptions({Key? key, required this.post, required this.postId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DonationOptionsState createState() => _DonationOptionsState();
}

class _DonationOptionsState extends State<DonationOptions> {
  double customAmount = 0;
  TextEditingController commentController = TextEditingController();
  late ScaffoldMessengerState _scaffoldMessengerState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the ScaffoldMessengerState
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Nominal Donasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 16),
            buildDonationOption(context, 5000),
            buildDonationOption(context, 10000),
            buildDonationOption(context, 15000),
            buildDonationOption(context, 20000),
            const SizedBox(height: 16),
            const Text(
              'Nominal Lainnya',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            buildCustomDonationField(context),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (customAmount > 0) {
                  setState(() {
                    showConfirmationDialog(context, customAmount);
                  });
                } else {
                  _scaffoldMessengerState.showSnackBar(
                    const SnackBar(
                      content: Text('Masukan Nominal.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5), // Mengatur sudut kotak
                ),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Donasi Rp ${customAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDonationOption(BuildContext context, double amount) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Menyesuaikan radius sudut
            side: const BorderSide(color: Colors.green), // Menetapkan border
          ),
        ),
      ),
      onPressed: () {
        showConfirmationDialog(context, amount);
      },
      child: Text(
        'Rp ${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget buildCustomDonationField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Masukkan Nominal',
        prefixText: 'Rp ',
        labelStyle: TextStyle(color: Colors.green),
        prefixStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Tidak ada yang perlu dilakukan di sini
      },
      onSubmitted: (value) {
        if (value.isNotEmpty && double.tryParse(value)! < 1000) {
          // Tampilkan pesan kesalahan dalam bentuk dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                  'Nominal harus minimal Rp 1000.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (value.isNotEmpty) {
          // Mengubah nilai jika nilai yang dimasukkan valid
          setState(() {
            customAmount = double.tryParse(value) ?? 0;
          });
        }
      },
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    String productId = '';
    if (amount == 5000) {
      productId = 'product_id_1';
    } else if (amount == 10000) {
      productId = 'product_id_2';
    } else if (amount == 15000) {
      productId = 'product_id_3';
    } else if (amount == 20000) {
      productId = 'product_id_4';
    } else {
      productId = 'product_id_custom';
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Donasi',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Menetapkan tebal huruf
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Anda akan mendonasikan ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Rp ${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: commentController,
                decoration:
                    const InputDecoration(labelText: 'Komentar (opsional)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Menetapkan warna latar belakang
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.white, // Menetapkan warna teks
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                donate(context, amount, email ?? '', 'Anonimous', productId,
                    widget.postId);
                sendComment(context, email ?? '', widget.postId,
                    commentController.text);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.green, // Menetapkan warna latar belakang
              ),
              child: const Text(
                'Donasi',
                style: TextStyle(
                  color: Colors.white, // Menetapkan warna teks
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> donate(BuildContext context, double amount, String email,
      String name, String productId, String postId) async {
    const String apiUrl =
        'https://sinergi-untuk-negeri.online/midtrans_testing/flutter_donate.php';
    Map<String, dynamic> requestData = {
      'amount': amount,
      'email': email,
      'name': name,
      'product_id': productId,
      'post_id': postId,
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Permintaan donasi berhasil!');
        }
        Map<String, dynamic> responseData = json.decode(response.body);
        String snapToken = responseData['snap_token'];
        String paymentUrl =
            'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';
            
        Future<void> launchUrl(String url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        await launchUrl(paymentUrl);
      } else {
        if (kDebugMode) {
          print(
              'Gagal melakukan permintaan donasi. Status code: ${response.statusCode}');
        }
        // ignore: use_build_context_synchronously
        _scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content:
                Text('Gagal melakukan permintaan donasi. Silakan coba lagi.'),
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      _scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text(
              'Terjadi kesalahan. Periksa koneksi internet Anda dan coba lagi.'),
        ),
      );
    }
  }

  Future<void> sendComment(
      BuildContext context, String email, String postId, String comment) async {
    const String commentApiUrl =
        'https://sinergi-untuk-negeri.online/midtrans_testing/komentar.php'; // Ganti dengan URL komentar yang sesuai
    Map<String, dynamic> commentData = {
      'email': email,
      'post_id': postId,
      'comment': comment,
    };
    try {
      final response = await http.post(
        Uri.parse(commentApiUrl),
        body: jsonEncode(commentData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Komentar terkirim!');
        }
      } else {
        if (kDebugMode) {
          print('Gagal mengirim komentar. Status code: ${response.statusCode}');
        }
        _scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim komentar. Silakan coba lagi.'),
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }

      _scaffoldMessengerState.showSnackBar(
        const SnackBar(
          content: Text(
              'Terjadi kesalahan. Periksa koneksi internet Anda dan coba lagi.'),
        ),
      );
    }
  }
}
