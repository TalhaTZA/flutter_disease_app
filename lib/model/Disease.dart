class Disease {
  final int id;
  final String name;
  final String number;

  Disease({this.id, this.name, this.number});

  factory Disease.fromJson(Map<String,dynamic> json) {

    return Disease(
      id: json['id'],
      number: json['number'],
      name: json['name']
    );
  }
}
