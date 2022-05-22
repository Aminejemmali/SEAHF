import 'dart:convert';

class  Speaker{
  late int id;
  late String Biography;
  late String speechtiltle;

  Speaker(int id,String fields) {
    var data2 = json.decode(fields);
    this.id = id;
    this.Biography = data2['Biography'];
    this.speechtiltle = data2['speechTitle'];
  }
  toJson() => {
    'pk':id,
    'Biography': Biography,
    'speechTitle': speechtiltle,


  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}