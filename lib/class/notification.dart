import 'dart:convert';

class  Notif{
late int id;
late String Subject;
late String Body;

Notif(int id,String fields) {
  var data2 = json.decode(fields);
  this.id = id;
  this.Subject = data2['titleNotificaion'];
  this.Body = data2['bodyNotificaion'];
}
toJson() => {
'pk':id,
'titleNotificaion': Subject,
'bodyNotificaion': Body,


};

@override
String toString() {
String text =json.encode(this.toJson());
return text;
}




}