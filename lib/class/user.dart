import 'dart:convert';

class User {
  late int id;
  late String photo;
  late String username;
  late String email;
  late String password;
  late String dateBirth;
  late String address1;
  late String city;
  late String country;
  late String phone;
  late String statutUser;

  User(int id,String fields){
    var data2 =json.decode(fields);
    this.id=id;
    this.photo=data2['photoProfile'];
    this.username=data2['username'];
    this.email=data2['email'];
    this.password=data2['password'];
    this.dateBirth=data2['dateBirth'];
    this.address1=data2['address01'];
    this.statutUser=data2['statutUser'];
    this.city=data2['city'];
    this.country=data2['country'];
    this.phone=data2['phone'];
  }
  toJson() => {
    'id':id,
    'photoProfile':photo,
    'username': username,
    'email': email,
    'password': password,
    'dateBirth': dateBirth,
    'address01': address1,
     'statutUser':statutUser,
    'city': city,
    'country': country,
    'phone': phone,
  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }


}