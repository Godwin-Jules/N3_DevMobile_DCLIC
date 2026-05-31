class User {
  final int? id;
  final String username;
  final String passwordHash;
  const User({this.id, required this.username, required this.passwordHash});
  Map<String, Object?> toMap() => {
    'id': id,
    'username': username,
    'password_hash': passwordHash,
  };
  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      passwordHash: map['password_hash'] as String,
    );
  }
}
