// ignore_for_file: non_constant_identifier_names

class Post {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String penyelenggara;
  final DateTime createdAt;
  final String updatedAt;
  final String target_funds;
  final String? funds_raised;
  final DateTime expired_at;
  final String is_penyaluran_dana;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.penyelenggara,
    required this.createdAt,
    required this.updatedAt,
    required this.target_funds,
    this.funds_raised,
    required this.expired_at,
    required this.is_penyaluran_dana,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      category: json['category'],
      penyelenggara: json['penyelenggara'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'],
      target_funds: json['target_funds'],
      funds_raised: json['funds_raised'],
      expired_at: DateTime.parse(json['expired_at']),
      is_penyaluran_dana: json['is_penyaluran_dana'],
    );
  }
}
