class User {
  final int id;
  final String name;
  final String password;
  final List<dynamic> diseases;

  User({this.id, this.name, this.password,this.diseases});

  factory User.fromJson(Map<String, dynamic> jsonUser) {
    return User(
        id: jsonUser['user']['id'],
        name: jsonUser['user']['name'],
        password: jsonUser['user']['password'],
        diseases : jsonUser['user']['diseases'] );
  }
}
