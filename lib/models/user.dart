class User {
  // コンストラクタ
  User({
    required this.id,
    required this.profileImageUrl,
  });

  // プロパティ
  final String id;
  final String profileImageUrl;

  // JSONからUserを生成するファクトリコンストラクタ
  factory User.fromJson(dynamic json) {
    return User(
      id: json['id'],
      profileImageUrl: ['profileImageUrl'] as String,
    );
  }
}
