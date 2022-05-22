import 'dart:convert';

class  Speaker{
  late int id;
  late String Biography;
  late String speechtiltle;
  late String namespeaker;

  Speaker(int id,String fields, String speakername) {
    var data2 = json.decode(fields);
    this.id = id;
    this.Biography = data2['Biography'];
    this.speechtiltle = data2['speechTitle'];
    this.namespeaker = speakername;
  }
  toJson() => {
    'pk':id,
    'Biography': Biography,
    'speechTitle': speechtiltle,
    'Name_Speaker': namespeaker,


  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}