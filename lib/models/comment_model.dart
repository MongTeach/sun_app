class Comment {
  final String id;
  final String email;
  final String postId;
  final String comment;
  final DateTime createdAt;
  Comment({
    required this.id,
    required this.email,
    required this.postId,
    required this.comment,
     required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'].toString(),
      email: json['email'].toString(),
      postId: json['post_id'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
