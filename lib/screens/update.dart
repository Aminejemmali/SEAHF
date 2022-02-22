
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodybite_app/class/country.dart';
import 'package:foodybite_app/class/state.dart';
import 'package:foodybite_app/class/user.dart';
import 'package:foodybite_app/screens/chatbot.dart';
import 'package:foodybite_app/screens/conference.dart';
import 'package:foodybite_app/screens/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Profilupdate extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfilupdateState();
  }
}
class ProfilupdateState extends State<Profilupdate> {
  int long = 0;
  int indexPage = 0;
  List<User> listUsers = [];
  bool editMode = false;

  TextEditingController name=new TextEditingController();
  TextEditingController mail=new TextEditingController();
  TextEditingController pass=new TextEditingController();
  TextEditingController date=new TextEditingController();
  TextEditingController addresse=new TextEditingController();
  TextEditingController phone=new TextEditingController();


  final ImagePicker imagePicker = ImagePicker();
  bool validateImage = false;
  late File image;
  var total_Countries = 250;
  var idCountry = 0;
  var idState = 0;
  var selectedCountry = "Select Country";
  var selectedStates = "Select State";
  var listCountry = [];
  late var listStates = [];

  getCoutry() async {
    final String res = await rootBundle.loadString('assets/sample.json');
    final d1 = await json.decode(res);
    for (int j = 0; j < total_Countries; j++) {
      var n = d1[j]['name'];
      Country c = new Country(j, n);
      listCountry.add(c);
    }
  }

  getState(int y) async {
    final String res = await rootBundle.loadString('assets/sample.json');
    final d1 = await json.decode(res);
    final d2 = d1[y] as Map;
    final d3 = d2["states"];
    int l = d3.length;
    for (int j = 0; j < l; j++) {
      var n = d1[y]['states'][j]['name'];
      States s = new States(j, n);
      listStates.add(s);
    }
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_User'));
    request.fields.addAll({
      'idUser': iduser.toString()
    });


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if (data1['Reponse'] == 'Success') {
        List data2 = json.decode(data1['User']);
        setState(() {
          long = data2.length;
          for (int i = 0; i < long; i++) {
            var id = data2[i]['pk'];
            var fields = json.encode(data2[i]['fields']);
            User user = new User(id, fields);
            listUsers.add(user);
          }
        });
      }
      else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error Connection',
          desc: data1['Reponse'],
          titleTextStyle: TextStyle(color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w900,),
          buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
          btnOkText: 'Ok',
          btnOkOnPress: () {},
        )
          ..show();
      }
    }
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error Connection',
        desc: response.reasonPhrase,
        titleTextStyle: TextStyle(color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w900,),
        buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )
        ..show();
    }
  }

  deleteConference(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse(
        'https://seahfwebserver.herokuapp.com/controllerlien/Delete_Conference'));
    request.fields.addAll({
      'idConference': id.toString()
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if (data1['Reponse'] == 'Success') {
        Navigator.of(context).pushReplacementNamed('ConferencesPage');
      }
      else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error Connection',
          desc: data1['Reponse'],
          titleTextStyle: TextStyle(color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w900,),
          buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
          btnOkText: 'Ok',
          btnOkOnPress: () {},
        )
          ..show();
      }
    }
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error Connection',
        desc: response.reasonPhrase,
        titleTextStyle: TextStyle(color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w900,),
        buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )
        ..show();
    }
  }

  updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Update_User'));
    request.fields.addAll({
      'idUser': listUsers[0].id.toString(),
      'username': listUsers[0].username,
      'email': listUsers[0].email,
      'phone': listUsers[0].phone,
      'password': listUsers[0].password,
      'dateBirth': listUsers[0].dateBirth,
      'address01': listUsers[0].address1,
      'country': listUsers[0].country,
      'city': listUsers[0].city,
      'statutUser': 'Activated'
    });
    if (validateImage == true) {
      request.files.add(
          await http.MultipartFile.fromPath('photoProfile', image.path));
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if (data1['Reponse'] == 'Success') {
        print('Success');
        prefs.setString('username',listUsers[0].username );
        prefs.setString('usermail',listUsers[0].email );


      }
      else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error Connection',
          desc: data1['Reponse'],
          titleTextStyle: TextStyle(color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w900,),
          buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
          btnOkText: 'Ok',
          btnOkOnPress: () {},
        )
          ..show();
      }
    }
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error Connection',
        desc: response.reasonPhrase,
        titleTextStyle: TextStyle(color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w900,),
        buttonsTextStyle: TextStyle(color: Colors.black, fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )
        ..show();
    }
  }

  uploadImage() async {
    final pickImage = await ImagePicker.pickImage(source: ImageSource.gallery , imageQuality: 80);
    if (pickImage != null) {
      setState(() {
        validateImage = true;
        image = File(pickImage.path);
      });
      print(pickImage.path);
    }
  }

  @override
  void initState() {
    getData();
    getCoutry();
    super.initState();
  }

  final screens =[
    ConferencesPage(),
    Favorite(),
    NotifPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0,),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(2.5),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (editMode == false) {
                          editMode = true;
                          name.text = listUsers[0].username;
                          mail.text = listUsers[0].email;
                          selectedCountry = listUsers[0].country;
                          selectedStates = listUsers[0].city;
                          date.text = listUsers[0].dateBirth;
                          addresse.text = listUsers[0].address1;
                          phone.text = listUsers[0].phone;
                        }
                        else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            animType: AnimType.BOTTOMSLIDE,
                            desc: 'Are you sure about updating your profil ?',
                            descTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,),
                            buttonsTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,),
                            btnOkText: 'Save',
                            btnOkOnPress: () {
                              setState(() {
                                listUsers[0].username=name.text;
                                listUsers[0].email=mail.text;
                                listUsers[0].country=selectedCountry;
                                listUsers[0].city=selectedStates;
                                listUsers[0].dateBirth=date.text;
                                listUsers[0].address1=addresse.text;
                                listUsers[0].phone=phone.text;
                                editMode = false;
                              });
                              updateUser();
                            },
                            btnCancelText: 'Don\'t Save',
                            btnCancelOnPress: () {
                              setState(() {
                                editMode = false;
                                validateImage = false;
                              });
                            },
                          ).show();
                        }
                      });
                    },
                    child: editMode == false ? Icon(Icons.edit) : Icon(Icons.save),
                    backgroundColor: editMode == false ? Color.fromRGBO(19, 37, 94, 1) : Colors.green,
                    elevation: 10,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.5),
                  child: FloatingActionButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        desc: 'Are you sure about deleting your profil ?',
                        descTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,),
                        buttonsTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,),
                        btnOkText: 'Yes',
                        btnOkOnPress: () {
                          //deleteConference(listConferences[0].id);
                        },
                        btnCancelText: 'Cancel',
                        btnCancelOnPress: () {},
                      )
                        ..show();
                    },
                    child: Icon(Icons.delete),
                    backgroundColor: Colors.red,
                    elevation: 10,
                  ),
                ),
              ],
            ),
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor:   Color.fromRGBO(19,37,94, 1),
          onTap: (index) {
            if(index==0){
              Navigator.pushReplacementNamed(context, 'Home1');
            }
            if(index==1){
              Navigator.pushReplacementNamed(context, 'favorite');
            }
            if(index==2){
              Navigator.pushReplacementNamed(context, 'Notification');
            }

          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor:   Color.fromRGBO(19,37,94, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'favorite',
              backgroundColor:   Color.fromRGBO(19,37,94, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'notifications',
              backgroundColor:   Color.fromRGBO(19,37,94, 1),
            ),
          ]

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(19, 37, 94, 1),
              Color.fromRGBO(83, 104, 157, 1),
            ],
          ),
        ),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: long,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  //Logo Supporter
                  InkWell(
                    child: Container(
                      height: 300,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: validateImage == true
                          ? Image.file(image)
                          : Image.network(listUsers[index].photo ==
                          'default_profile_picture.jfif'
                          ? "https://seahfwebserver.herokuapp.com/media/ddefault_profile_picture.jfif"
                          : "https://seahfwebserver.herokuapp.com/media/profile_pics/${listUsers[index].photo}", fit: BoxFit.fill,),
                    ),
                    onTap: () {
                      if(editMode==true){
                        uploadImage();
                      }

                    },
                  ),
                  //Username
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Username:', style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                      leading: Container(height: double.infinity,
                          child: Icon(Icons.title, color: Colors.white,)),
                      subtitle: editMode == false
                          ? Text(listUsers[0].username, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
                          : TextFormField(style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        controller: name,
                        decoration: InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                  ),
                  //Address01
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Address01:', style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                      leading: Container(height: double.infinity,
                          child: Icon(Icons.home_sharp, color: Colors.white,)),
                      subtitle: editMode == false
                          ? Text(listUsers[0].address1, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
                          : TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        controller: addresse,
                        decoration: InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                  ),
                  //Country
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: editMode == false
                        ? ListTile(
                        title: Text('Country:', style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),),
                        leading: Container(height: double.infinity,
                            child: Icon(
                              Icons.home_sharp, color: Colors.white,)),
                        subtitle: Text(listUsers[0].country,
                          style: TextStyle(color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),)
                    )
                        : DropdownButton(
                      iconSize: 30,
                      icon: Icon(Icons.arrow_drop_up,),
                      alignment: Alignment.center,
                      underline: Divider(thickness: 0,),
                      hint: Text(selectedCountry, style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),),
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      items: listCountry.map((e) =>
                          DropdownMenuItem(
                            child: Text('${e.name}'), value: e.name,)).toList(),
                      onChanged: (value) {
                        setState(() {
                          listStates = [];
                          selectedStates = 'Select State';
                          selectedCountry = value.toString();
                          for (int z = 0; z < total_Countries; z++) {
                            if (listCountry[z].name == value.toString()) {
                              idCountry = listCountry[z].id;
                            }
                          }
                          getState(idCountry);
                        });
                      },
                    ),
                  ),
                  //State
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: editMode == false
                        ? ListTile(
                        title: Text('State:', style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),),
                        leading: Container(height: double.infinity,
                            child: Icon(
                              Icons.home_sharp, color: Colors.white,)),
                        subtitle: Text(listUsers[0].city,
                          style: TextStyle(color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),)
                    )
                        : DropdownButton(
                      iconSize: 30,
                      icon: Icon(Icons.arrow_drop_up,),
                      alignment: Alignment.center,
                      underline: Divider(thickness: 0,),
                      hint: Text(selectedStates, style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),),
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      items: listStates.map((e) =>
                          DropdownMenuItem(
                            child: Text('${e.name}'), value: e.name,)).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStates = value.toString();
                        });
                      },
                    ),
                  ),
                  //Email
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Email:', style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                      leading: Container(height: double.infinity,
                          child: Icon(Icons.map, color: Colors.white,)),
                      subtitle: editMode == false
                          ? Text(listUsers[0].email, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
                          : TextFormField(keyboardType: TextInputType.text, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        controller: mail,
                        decoration: InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                  ),
                  //Phone
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(title: Text('Phone:', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                      leading: Container(height: double.infinity,
                          child: Icon(
                            Icons.text_snippet, color: Colors.white,)),
                      subtitle: editMode == false
                          ? Text(listUsers[0].phone, style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),)
                          : TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        style: TextStyle(color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        controller: phone,
                        decoration: InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                  ),
                  //Date
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(119, 148, 225, 0.7),
                          Color.fromRGBO(119, 148, 225, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2, 12, 30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Date:', style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),),
                      leading: Container(height: double.infinity,
                          child: Icon(
                            Icons.info_outline_rounded, color: Colors.white,)),
                      subtitle: editMode == false
                          ? Text(listUsers[0].dateBirth,
                        style: TextStyle(color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),)
                          : TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        style: TextStyle(color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        controller: date,
                        decoration: InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                  ),


                ],
              );
            }
        ),
      ),

    );
  }
}