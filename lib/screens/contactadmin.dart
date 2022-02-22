import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/chatbot.dart';
import 'package:foodybite_app/screens/conference.dart';
import 'package:foodybite_app/screens/favorite.dart';
import 'package:http/http.dart' as http;

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ContactPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ContactPageState();
  }
}
class ContactPageState extends State<ContactPage>{

  TextEditingController subjectController= new TextEditingController();
  TextEditingController bodyController= new TextEditingController();

  sendContact(String subject,String body ) async {
    final prefs = await SharedPreferences.getInstance();
    String? email= await prefs.getString('usermail');
    prefs.remove('emailSelected');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/contactAdmin'));
    request.fields.addAll({
      'subject': subject,
      'body': body,
      'email': email.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Received'){
        Navigator.of(context).pushReplacementNamed('Home1');
      }
      else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title:'Error Connection' ,
          desc: data1['Reponse'],
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
          buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
          btnOkText: 'Ok',
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
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
        buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushReplacementNamed('Home1');
        }, icon: Icon(Icons.arrow_back),iconSize: 25),
        title: Text('Contact',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19,37,94, 1) ,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(19,37,94, 1),
              Color.fromRGBO(83,104,157, 1),
            ],
          ),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Stack(children: [
              Opacity(child: Image.asset("assets/images/seahf.png", color: Colors.black), opacity: 0.6),
              ClipRect(child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Image.asset("assets/images/seahf.png")))
            ]),
            //SubjectInput
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(119,148,225, 0.7),
                    Color.fromRGBO(119,148,225, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(2,12,30, 1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(2, 5), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: subjectController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
                cursorWidth: 5,
                style:TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w900,) ,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text('Subject',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  prefixIcon: Icon(Icons.title,color: Colors.white,),
                ),
              ),
            ),
            //BodyInput
            Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: EdgeInsets.only(right: 30),
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(119,148,225, 0.7),
                      Color.fromRGBO(119,148,225, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(2,12,30, 1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text('Body',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  leading: Icon(Icons.password,color: Colors.white,),
                  subtitle: TextFormField(
                    controller: bodyController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.white,
                    cursorWidth: 10,
                    maxLines: 14,
                    minLines: 1,
                    style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,) ,
                    decoration: InputDecoration(border: InputBorder.none,),
                  ),
                )
            ),
            //Send
            InkWell(
              onTap: (){
                var subject=subjectController.text;
                var body=bodyController.text;
                if(subject.isEmpty ||body.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Color.fromRGBO(2,12,30, 1),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Empty",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ));
                }
                else{
                  sendContact(subject, body);
                }

              },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child:Icon(Icons.send,color: Colors.white,size: 30,),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(2,12,30, 1),
                          Color.fromRGBO(19,37,94, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(2,12,30, 1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ],
              ) ,
            ),

          ],
        ),
      ),
    );
  }

}