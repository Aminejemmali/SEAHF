import 'dart:convert';

class States {
  late int id;
  late String name;
  States(int id,String name) {
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