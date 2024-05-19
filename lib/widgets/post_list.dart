import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../screens/home/sub_home/PostDetailPage.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;

  const PostList({Key? key, required this.posts}) : super(key: key);

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final expiredAt = posts[index].expired_at;
        final remainingDays = expiredAt.difference(DateTime.now()).inDays;

        // Memeriksa apakah tanggal kedaluwarsa sudah berlalu
        if (remainingDays >= 0) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => _navigateToDetail(context, posts[index]),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://sinergi-untuk-negeri.online/campaign/images/${posts[index].imageUrl}',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              posts[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  posts[index].penyelenggara,
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
                                    ).format(double.tryParse(
                                            posts[index].funds_raised ?? '0') ??
                                        0),
                                    style: const TextStyle(
                                      color: Colors
                                          .green, // Mengatur warna teks untuk data funds_raised
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
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
                                          horizontal: 8,
                                          vertical: 4), // Sesuaikan padding badge
                                      decoration: BoxDecoration(
                                        color: remainingDaysColor(
                                            posts[index]
                                                .expired_at), // Warna latar belakang berdasarkan sisa hari
                                        borderRadius: BorderRadius.circular(
                                            20), // Menyesuaikan dengan bentuk badge
                                      ),
                                      child: Text(
                                        calculateRemainingDays(posts[index]
                                            .expired_at), // Teks yang ingin ditampilkan
                                        style: const TextStyle(
                                          color: Colors
                                              .white, // Warna teks putih untuk kontras
                                          fontWeight: FontWeight
                                              .bold, // Teks tebal (bold)
                                          fontSize: 10, // Ukuran font
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 224, 224, 224),
                height: 1, // Ketebalan garis
              ),
            ],
          );
        } else {
          // Jika tanggal kedaluwarsa sudah berlalu, kembalikan widget kosong
          return const SizedBox.shrink();
        }
      },
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
