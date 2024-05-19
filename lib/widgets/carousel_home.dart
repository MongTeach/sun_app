import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/post_model.dart';

import 'package:shimmer/shimmer.dart';

import '../screens/home/sub_home/PostDetailPage.dart';

class CarouselHome extends StatefulWidget {
  final VoidCallback refreshCallback;
  const CarouselHome({Key? key, required this.refreshCallback})
      : super(key: key);

  @override
  CarouselHomeState createState() => CarouselHomeState();
}

class CarouselHomeState extends State<CarouselHome> {
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPosts();
  }

  Future<void> refreshData() async {
    setState(() {
      _futurePosts = fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerSlider();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          final List<Post> posts = snapshot.data!;
          return _buildCarouselSlider(posts);
        }
      },
    );
  }

  Widget _buildShimmerSlider() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'PopulerSUN',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              disableCenter: true,
              viewportFraction: 1.0,
            ),
            items: List.generate(3, (index) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    String errorMessage = 'Terjadi kesalahan.';
    if (error is SocketException) {
      errorMessage = 'Tidak ada koneksi internet.';
    } else if (error is TimeoutException) {
      errorMessage = 'Waktu tunggu habis. Harap coba lagi.';
    } else if (error is http.ClientException) {
      errorMessage = 'Error communicating with server.';
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(errorMessage),
      ),
    );
  }

  Widget _buildCarouselSlider(List<Post> posts) {
    // Urutkan daftar posts berdasarkan tanggal createdAt (dari yang terlama)
    posts.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Ambil tiga data post pertama (dengan tanggal terlama)
    List<Post> oldestPosts = posts.take(3).toList();

    return RefreshIndicator(
      onRefresh: refreshData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'PopulerSUN',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              disableCenter: true,
              viewportFraction: 1.0,
            ),
            items: oldestPosts.map((post) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () => _navigateToDetail(context, post),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://sinergi-untuk-negeri.online/campaign/images/${post.imageUrl}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
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

Future<List<Post>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse(
        'https://sinergi-untuk-negeri.online/app/api/api_donasi.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception();
    }
  } catch (e) {
    if (e is SocketException) {
      throw Exception('Tidak ada koneksi internet.');
    } else {
      throw Exception();
    }
  }
}
