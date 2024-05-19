import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'search.dart';
import 'sub_home/BencanaAlam_category.dart';
import 'sub_home/KebutuhanListrik_category.dart';
import 'sub_home/KegiatanSosial_category.dart';
import 'sub_home/Lingkungan_category.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../utils/api.dart';
import '../../widgets/carousel_home.dart';
import '../../widgets/post_list.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/urutkan_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _postsFuture;
  late Future<List<Comment>> _commentFuture;
  late List<Post> allPosts = [];
  String _urutan = 'terbaru';
  final GlobalKey<CarouselHomeState> _carouselHomeKey = GlobalKey();

  void _performSearch(String query) {
    setState(() {});
    // Perform search here
    List<Post> searchResults = [];
    if (query.isNotEmpty) {
      searchResults = allPosts
          .where(
              (post) => post.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Navigate to the search page with search results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(searchResults),
      ),
    );
  }

  // Fungsi untuk mengubah urutan
  void _onUrutkanSelected(String? value) {
    // Tambahkan tanda tanya setelah String
    setState(() {
      _urutan = value ?? 'terbaru'; // Tambahkan penanganan nilai null
    });
  }

  // Fungsi untuk fetch data
  void _fetchData() {
    _postsFuture = ApiPost.fetchPosts();
    _commentFuture = ApiComment.fetchcomment();
    _postsFuture.then((posts) {
      if (mounted) {
        setState(() {
          allPosts = posts;
        });
      }
    });
  }

  // Fungsi untuk refresh data
  Future<void> refreshData() async {
    setState(() {
      _postsFuture = ApiPost.fetchPosts();
      _commentFuture = ApiComment.fetchcomment();
      _carouselHomeKey.currentState?.refreshData();
    });
    final posts = await _postsFuture;
    if (mounted) {
      setState(() {
        allPosts = posts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Text(
            'Beranda',
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
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 224, 224, 224),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: SearchWidget(
                    onSearch: _performSearch,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Kategori',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),

              // Add CategoryIcon widget here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 14.0, // Jarak horizontal antara widget
                  runSpacing: 14.0, // Jarak vertical antara widget
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    CategoryIcon(
                      icon: 'assets/images/illustration-environment.png',
                      label: 'Lingkungan',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LingkunganCategory()),
                        );
                      },
                    ),
                    CategoryIcon(
                      icon: 'assets/images/emoji-solar-energy.png',
                      label: 'Kebutuhan Listrik',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const kebutuhanListrikCategory()),
                        );
                      },
                    ),
                    CategoryIcon(
                      icon: 'assets/images/icon-charity-9wV.png',
                      label: 'Kegiatan Sosial',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const KegiatanSosialCategory()),
                        );
                      },
                    ),
                    CategoryIcon(
                      icon: 'assets/images/icon-insurance-disaster.png',
                      label: 'Bencana Alam',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BencanaAlamCategory()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // end of CategoryIcon widget
              const SizedBox(height: 16.0),
              Container(
                height: 1, // Tinggi kotak pemisah
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

              CarouselHome(
                key: _carouselHomeKey,
                refreshCallback:
                    refreshData, // Memberikan callback refreshData ke CarouselHome
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

              // filter dan urutkan
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Penggalangan Dana Lainya',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik'),
                ),
              ),
              UrutkanWidget(
                onUrutkanSelected:
                    _onUrutkanSelected, // Menggunakan fungsi untuk mengubah urutan
              ),
              // end of filter dan urutkan
              const SizedBox(height: 16.0),

              // Add PostList widget here
              FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerPostList();
                  } else if (snapshot.hasError) {
                    String errorMessage = 'Terjadi kesalahan.';
                    if (snapshot.error is SocketException) {
                      errorMessage = 'Tidak ada koneksi internet.';
                    } else if (snapshot.error is TimeoutException) {
                      errorMessage = 'Waktu tunggu habis. Harap coba lagi.';
                    } else {
                      errorMessage =
                          'Terjadi kesalahan: ${snapshot.error.toString()}';
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(errorMessage),
                      ),
                    );
                  } else {
                    List<Post>? posts = snapshot.data;
                    if (posts == null || posts.isEmpty) {
                      return const Center(child: Text('No posts available.'));
                    }
                    posts = posts.reversed.toList();
                    posts = posts.take(5).toList();
                    if (_urutan == 'terlama') {
                      posts = posts.reversed.toList();
                    }
                    return PostList(posts: posts);
                  }
                },
              ),

              // end of PostList widget
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
              // Add Comment Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Komentar Terbaru',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              // end of Comment Section

              // Add Comment Slider
              FutureBuilder<List<Comment>>(
                future: _commentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerCommentList();
                  } else if (snapshot.hasError) {
                    String errorMessage = 'Terjadi kesalahan.';
                    if (snapshot.error is SocketException) {
                      errorMessage = 'Tidak ada koneksi internet.';
                    } else if (snapshot.error is TimeoutException) {
                      errorMessage = 'Waktu tunggu habis. Harap coba lagi.';
                    } else {
                      errorMessage =
                          'Terjadi kesalahan: ${snapshot.error.toString()}';
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(errorMessage),
                      ),
                    );
                  } else {
                    List<Comment>? komentar = snapshot.data;
                    komentar = komentar!.reversed.toList();
                    return buildCommentSlider(komentar);
                  }
                },
              ),
              // end of Comment Slider
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer comment effect
  Widget _buildShimmerPostList() {
    return SizedBox(
      height: 200.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          },
        ),
      ),
    );
  }
  // end Shimmer comment effect

  Widget _buildShimmerCommentList() {
    return SizedBox(
      height: 200.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 100.0,
                        height: 16.0,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    height: 16.0,
                    color: Colors.grey[200],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCommentSlider(List<Comment> comments) {
    final List<Comment> limitedComments = comments.take(5).toList();
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: limitedComments.length,
        itemBuilder: (context, index) {
          return buildCommentItem(limitedComments[index]);
        },
      ),
    );
  }

  Widget buildCommentItem(Comment comment) {
    // Menghapus bagian "@gmail.com"
    String emailWithoutDomain = comment.email.split('@').first;

    String truncatedComment = comment.comment.length > 20
        ? '${comment.comment.substring(0, 20)}...' // Jika komentar lebih dari 20 karakter, potong dan tambahkan ...
        : comment
            .comment; // Jika komentar kurang dari atau sama dengan 20 karakter, gunakan komentar asli

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 8.0),
                Text(
                  emailWithoutDomain,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(color: Colors.grey), // Divider di bawah email
            const SizedBox(height: 8.0),
            Text(
              truncatedComment,
            ),
            const SizedBox(height: 40.0),
            const Text(
              'Doa orang baik',
              style: TextStyle(color: Colors.grey),
            ), // Teks "Doa orang baik"
            const SizedBox(height: 4.0),
            Text(
              'Posted on ${DateFormat('dd-MM-yyyy').format(comment.createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ), // Menampilkan tanggal atau waktu komentar dibuat
          ],
        ),
      ),
    );
  }

  // end of Comment item
}

// category icon
class CategoryIcon extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 30,
            height: 30,
          ),
          const SizedBox(height: 8.0),
          Text.rich(
            TextSpan(
              children: _splitLabel(),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Sesuaikan dengan kebutuhan
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _splitLabel() {
    List<InlineSpan> spans = [];

    // Split label into words
    List<String> words = label.split(' ');

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.toLowerCase() == 'listrik' ||
          word.toLowerCase() == 'sosial' ||
          word.toLowerCase() == 'alam') {
        // Print 'listrik', 'sosial', or 'alam' in a new line
        spans.add(const TextSpan(text: '\n'));
      }
      spans.add(TextSpan(text: word + (i < words.length - 1 ? ' ' : '')));
    }

    return spans;
  }
}
