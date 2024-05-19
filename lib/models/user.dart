class User {
  final String id;
  final String username;
  final String email;
  final String nomortelepon;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.nomortelepon,
    required this.password,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      nomortelepon: json['nomortelepon'],
      password: json['password'],
    );
  }
}
