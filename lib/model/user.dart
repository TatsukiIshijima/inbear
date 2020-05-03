

class User {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  User(
    this.uid,
    this.name,
    this.email,
    this.createdAt
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'created_at': createdAt
  };
}