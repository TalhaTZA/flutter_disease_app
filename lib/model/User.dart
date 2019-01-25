class User {
  final int id;
  final String name;
  final String password;

  User({this.id, this.name, this.password});

  factory User.fromJson(Map<String, dynamic> jsonUser) {
    return User(
        id: jsonUser['id'],
        name: jsonUser['name'],
        password: jsonUser['password']);
  }
}
