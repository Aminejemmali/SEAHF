import 'dart:convert';

class  Committee{
  late int id;
  late String name;
  late String role;


  Committee(int id,String fields) {
    var data2 = json.decode(fields);
    this.id = id;
    this.name = data2['name'];
    this.role = data2['role'];

  }
  toJson() => {
    'idCommittee':id,
    'name': name,
    'role': role,



  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}