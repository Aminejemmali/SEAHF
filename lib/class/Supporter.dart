import 'dart:convert';

class  Supporter{
  late int id;
  late String logosuppoter;
  late String titlesupporter;
  late String emailsupporter;
  late String phonesupporter;


  Supporter(int id,String fields) {
    var data2 = json.decode(fields);
    this.id = id;
    this.logosuppoter = data2['logoSupporter'];
    this.titlesupporter = data2['titleSupporter'];
    this.emailsupporter = data2['emailSupporter'];
    this.phonesupporter = data2['phoneSupporter'];
  }
  toJson() => {
    'pk':id,
    'logoSupporter': logosuppoter,
    'titleSupporter': titlesupporter,
    'emailSupporter': emailsupporter,
    'phoneSupporter':phonesupporter,


  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}