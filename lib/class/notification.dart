import 'dart:convert';

class  Notif{
late int id;
late String Subject;
late String Body;

Notif(int id,String fields) {
  var data2 = json.decode(fields);
  this.id = id;
  this.Subject = data2['titleNotification'];
  this.Body = data2['bodyNotification'];
}
toJson() => {
'pk':id,
'titleNotification': Subject,
'bodyNotification': Body,


};

@override
String toString() {
String text =json.encode(this.toJson());
return text;
}




}