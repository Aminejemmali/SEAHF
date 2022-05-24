import 'dart:convert';

class  Topics{
  late int id;
  late String titletopic;



  Topics(int id,String fields) {
    var data2 = json.decode(fields);
    this.id = id;
    this.titletopic = data2['title'];

  }
  toJson() => {
    'pk':id,
    'title': titletopic,



  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}