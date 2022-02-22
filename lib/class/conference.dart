import 'dart:convert';

class Conference {
  late int id;
  late String banner;
  late String titleConference;
  late String dateConference;
  late String address01;
  late String country;
  late String city;
  late String coordinates;
  late String SCOPE;
  late String moreInformation;
  late int numPlace;
  late String statutConference;
  late String shortTitle;

  Conference(int id,String fields){
    var data2 =json.decode(fields);
    this.id=id;
    this.banner=data2['banner'];
    this.titleConference=data2['titleConference'];
    this.dateConference=data2['dateConference'];
    this.address01=data2['address01'];
    this.country=data2['country'];
    this.city=data2['city'];
    this.coordinates=data2['coordinates'];
    this.SCOPE=data2['SCOPE'];
    this.moreInformation=data2['moreInformation'];
    this.numPlace=data2['numPlace'];
    this.statutConference=data2['statutConference'];

    String short='';
    List<String> not=['and','on','&'];
    var d1=this.titleConference.toLowerCase();
    var d2=d1.split(' ');
    for(int i=0;i<d2.length;i++){
      if(!not.contains(d2[i])){
        var d3=d2[i][0].toUpperCase()+d2[i].substring(0);

        short=short+d2[i][0].toUpperCase();
      }
    }

    this.shortTitle=short;
  }
  toJson() => {
    'id':id,
    'banner': banner,
    'titleConference': titleConference,
    'dateConference':dateConference,
    'address01': address01,
    'country': country,
    'city': city,
    'coordinates': coordinates,
    'SCOPE': SCOPE,
    'moreInformation': moreInformation,
    'numPlace': numPlace,
    'statutConference': statutConference,

  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}