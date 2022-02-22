import 'dart:convert';

class Country {
  late int id;
  late String name;
  Country(int id,String name) {
    this.id=id;
    this.name=name;
  }

  toJson() => {
    'id':id,
    'name':name,
  };
  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }
}