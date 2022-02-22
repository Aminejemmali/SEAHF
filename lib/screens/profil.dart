import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/user.dart';
import 'package:foodybite_app/pallete.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_loading/flutter_loading.dart';



class Profil extends StatefulWidget {
  String id,name,mail,pass,date,add,city,country,phone;
  Profil({ Key? key,required this.id,
  required this.name,required this.mail,
    required this.pass,
    required this.date,
    required this.add,

    required this.city,
    required this.country,
    required this.phone,
  }) : super(key: key);


  State<Profil> createState() => _AccountUpdateState();
}
class _AccountUpdateState extends State<Profil> {
  late TextEditingController name=TextEditingController()..text=widget.name;
  late TextEditingController mail=TextEditingController()..text=widget.mail;
  late TextEditingController pass=TextEditingController()..text=widget.pass;
  late TextEditingController date=TextEditingController()..text=widget.date;
  late TextEditingController addresse=TextEditingController()..text=widget.add;
  late TextEditingController city=TextEditingController()..text=widget.city;
  late TextEditingController country=TextEditingController()..text=widget.country;
  late TextEditingController phone=TextEditingController()..text=widget.phone;

  late File image;
  Path? path;

  bool show=true;
  bool valid=false;
  int long =0;

  bool isLoading = true;
  Future getImage()async{
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery , imageQuality: 80);

      print(pickedFile.path);
      if(mounted){
      setState(() {
        image = File(pickedFile.path);
        valid=true;
      });}
    }


  Future <void> update(  ) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Update_User'));
  request.fields.addAll({
    'idUser': widget.id,
    'username': name.text,
    'email': mail.text,
    'password': pass.text,
    'dateBirth': date.text,
    'address01': addresse.text,
    'city': city.text,
    'country': country.text,
    'phone': phone.text,
    'statutUser':"Activaded²"
  });
  request.files.add(await http.MultipartFile.fromPath('photoProfile',image.path));
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
  var s=await response.stream.bytesToString();
  Map<String, dynamic> data1 = json.decode(s);
  if(data1['Reponse']=='success'){
    Navigator.pushNamed(context, 'Profilview');
    print('success');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("success"),));
  }

  else {
  print('erreur');
  }
  }}
  List<User> listUser=[];
  Future<Null> getData() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_User'));
    request.fields.addAll({
      'idUser': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        print('111');
        List data2 = json.decode(data1['User']);
        if (this.mounted){
          setState(() {
            long = data2.length;
            var id = data2[0]['pk'];
            var fields = json.encode(data2[0]['fields']);
            User user = new User(id, fields);
            listUser.add(user);
             isLoading = false;


          });}
      }
      else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title:'Error Connection' ,
          desc: data1['Reponse'],
          btnOkOnPress: () {},
        )..show();
      }
    }
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title:'Error Connection' ,
        desc: response.reasonPhrase,
        btnOkOnPress: () {},
      )..show();
    }
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
      body:  isLoading ?
      Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: SpinKitCircle(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                );
              },
            ),
          )
      )
          :

      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(142, 158, 171, 1),
              Color.fromRGBO(238, 242, 243, 1),
            ],
          ),
        ),
          child: ListView(
          children: [
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: (){
                    getImage();
                  },
                  child:Container(
                    child: Center(
                      child: valid==true ?
                      Image.file(image, fit: BoxFit.fill,height: 150,width: 100,): Image.network("https://seahfwebserver.herokuapp.com/media/profile_pics/${listUser[0].photo}", fit: BoxFit.fill,height: 100,width: 100,),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(

                  children: [


                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: name,

                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          labelText: "name",


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: mail,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.mail),
                          labelText: "mail",


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: pass,
                        obscureText: show,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.lock),
                          labelText: "password",



                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),

                          ),
                          suffix: InkWell(
                              child: Text('Show'),
                              onTap:(){
                                setState(() {
                                  show=!show;
                                });}),
                        ),
                      ),),
                    SizedBox(
                      height: 30,
                    ),
                    Column(

                      children: [


                        Container(
                          width:350,
                          child:
                          TextField(
                            controller: date,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: Icon(Icons.date_range),
                               labelText: "Date",

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width:350,
                          child:
                          TextField(
                            controller: addresse,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: Icon(Icons.home),
                              labelText: "Address",


                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),

                        Container(
                          width:350,
                          child:
                          TextField(
                            controller: city,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: Icon(Icons.home_work_outlined),
                              labelText: "City",


                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width:350,
                          child:
                          TextField(
                            controller: country,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: Icon(Icons.home_work_sharp),
                              labelText: "Country",


                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width:350,
                          child:
                          TextField(
                            controller: phone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: Icon(Icons.phone),
                              labelText: "Phone",


                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      ElevatedButton(
                        onPressed: (){
                          update();
                          },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(210,65),
                            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.deepPurpleAccent),
                        child: const Text('Update'),
                      ),),
                        SizedBox(
                          height: 25,
                        ),



                  ],
                )
              ],
            ),
        ],
      )

    ),
      );








  }}