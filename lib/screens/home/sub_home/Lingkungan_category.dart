import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/post_model.dart';
import '../../../services/api_service.dart';
import 'PostDetailPage.dart';

class LingkunganCategory extends StatefulWidget {
  const LingkunganCategory({Key? key}) : super(key: key);

  @override
  _LingkunganCategoryState createState() => _LingkunganCategoryState();
}

class _LingkunganCategoryState extends State<LingkunganCategory> {
  late Future<List<Post>> _postsFuture;
  final ApiService _apiService =
      ApiService('https://sinergi-untuk-negeri.online');
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    _postsFuture = _apiService.fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Load more data when user reaches the end of the list
      if (!_isLoading) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() {
      _isLoading = true;
    });
    // Fetch more posts
    try {
      final List<Post> morePosts = await _apiService.fetchPosts();
      // Add the new posts to the existing list
      // (assuming fetchPosts() returns additional posts)
      final List<Post> currentPosts = await _postsFuture;
      final List<Post> updatedPosts = currentPosts..addAll(morePosts);
      setState(() {
        _postsFuture = Future.value(updatedPosts);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error loading more posts: $error');
      }
    }
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
            'lingkungan',
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
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print('Error: ${snapshot.error}');
            }
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Post> posts = snapshot.data ?? [];
            final filteredPosts = posts
                .where((post) => post.category.toLowerCase() == 'lingkungan')
                .toList();
            return ListView.builder(
              controller: _scrollController,
              itemCount: filteredPosts.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < filteredPosts.length) {
                  final post = filteredPosts[index];
                  // Menghitung persentase donasi terhadap target
                  double donationPercentage =
                      double.parse(post.funds_raised ?? '0') /
                          double.parse(post.target_funds);
                  final expiredAt = post.expired_at;
                  final remainingDays =
                      expiredAt.difference(DateTime.now()).inDays;

                  if (remainingDays >= 0) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 2.0),
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
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(context, post),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://sinergi-untuk-negeri.online/campaign/images/${post.imageUrl}',
                                      placeholder: (context, url) =>
                                          _buildShimmerImage(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      cacheManager: DefaultCacheManager(),
                                      width: 130,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                                                    post.funds_raised ?? '0') ??
                                                0),
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: LinearProgressIndicator(
                                        value: donationPercentage,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                        children: [
                                          WidgetSpan(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: remainingDaysColor(
                                                    post.expired_at),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                calculateRemainingDays(
                                                    post.expired_at),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return _buildLoader();
                }
                return null;
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4), // Spacer
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.white,
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
