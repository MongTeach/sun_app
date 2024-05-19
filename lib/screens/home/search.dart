import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Import library untuk NumberFormat
import '../../models/post_model.dart';
import 'sub_home/PostDetailPage.dart';

class SearchPage extends StatefulWidget {
  final List<Post> searchResults;

  const SearchPage(this.searchResults, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _maxVisibleCount = 10;

    String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}'; // Ubah sesuai dengan format yang Anda inginkan
  }

  String calculateRemainingDays(DateTime expiredAt) {
    final now = DateTime.now();
    final difference = expiredAt.difference(now);
    final remainingDays = difference.inDays;

    if (remainingDays > 0) {
      return 'Sisa waktu: $remainingDays hari';
    } else if (remainingDays == 0) {
      return 'Hari ini adalah batas waktu';
    } else {
      return 'Batas waktu telah berlalu';
    }
  }

  Color remainingDaysColor(DateTime expiredAt) {
    final now = DateTime.now();
    final difference = expiredAt.difference(now);
    final remainingDays = difference.inDays;

    if (remainingDays > 7) {
      return Colors.green; // Warna hijau untuk lebih dari 7 hari tersisa
    } else if (remainingDays > 0) {
      return Colors.orange; // Warna oranye untuk 1-7 hari tersisa
    } else {
      return Colors.red; // Warna merah untuk batas waktu telah berlalu
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Post> visibleResults =
        widget.searchResults.take(_maxVisibleCount).toList();

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
            'Hasil Pencarian',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount:
              visibleResults.length + 1, // tambahkan 1 untuk tombol "load more"
          itemBuilder: (context, index) {
            if (index == visibleResults.length) {
              // Tampilkan tombol "load more" di akhir daftar jika jumlah data lebih dari 10
              if (widget.searchResults.length > _maxVisibleCount) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Tambahkan 10 data berikutnya ke _maxVisibleCount
                        _maxVisibleCount += 10;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 66, 190, 70),
                      ),
                    ),
                    child: const Text(
                      'Lihat lainnya',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0),
                    ),
                  ),
                );
              } else {
                // Jika jumlah data tidak melebihi 10, maka tidak perlu menampilkan tombol "load more"
                return const SizedBox(); // Mengembalikan widget kosong
              }
            }
            return buildListItem(visibleResults[index]);
          },
        ),
      ),
    );
  }

  Widget buildListItem(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl:
                  'https://sinergi-untuk-negeri.online/campaign/images/${post.imageUrl}',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              width: 100,
              height: 100, // Tinggi gambar ditingkatkan menjadi 200
            ),
          ),
          title: Text(
            post.title,
            style: const TextStyle(
              fontSize: 16, // Customized font size
              fontWeight: FontWeight.bold, // Customized font weight
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.penyelenggara,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 12,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Terkumpul ',
                    ),
                    TextSpan(
                      text: NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                      ).format(double.tryParse(post.funds_raised ?? '0') ?? 0),
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  children: [
                    WidgetSpan(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: remainingDaysColor(post.expired_at),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          calculateRemainingDays(post.expired_at),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          onTap: () {
            _navigateToDetail(context, post);
          },
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post),
      ),
    );
  }
}
