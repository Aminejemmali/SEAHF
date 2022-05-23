import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/formulaires/Auteur.dart';
import 'package:foodybite_app/formulaires/Industrial.dart';
import 'package:foodybite_app/formulaires/Instructor.dart';
import 'package:foodybite_app/formulaires/Speaker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {

}

class Participation extends StatefulWidget {


  @override
  State<Participation> createState() => _ParticipationState();
}

class _ParticipationState extends State<Participation> {
 attendee() async{
   final prefs = await SharedPreferences.getInstance();
   String? iduser = await prefs.getString('iduser');
   String? idconf = await prefs.getString('idconf');
  print(iduser.toString());
  var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Demande_Participant_Attendee'));
   request.fields.addAll({
     'idUser': iduser.toString(),
     'idConference': idconf.toString(),
   });


   http.StreamedResponse response = await request.send();

   if (response.statusCode == 200) {
     var s = await response.stream.bytesToString();
     Map<String, dynamic> data1 = json.decode(s);
     setState(() {
       if (data1['Reponse'] == 'Success') {
         AwesomeDialog(
           context: context,
           dialogType: DialogType.WARNING,
           animType: AnimType.BOTTOMSLIDE,
           title:'done' ,
           desc: 'Done',
           btnOkOnPress: () {},
         )..show();
       }
       else if (data1['Reponse'] == 'Exist') {
         AwesomeDialog(
           context: context,
           dialogType: DialogType.WARNING,
           animType: AnimType.BOTTOMSLIDE,
           title:'Error' ,
           desc: 'you are already attendee in this conference',
           btnOkOnPress: () {},
         )..show();
       }
       else {
         AwesomeDialog(
           context: context,
           dialogType: DialogType.WARNING,
           animType: AnimType.BOTTOMSLIDE,
           title:'Error Connection' ,
           desc: data1['Reponse'],
           btnOkOnPress: () {},
         )..show();;
       }
     });
   }
 }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Participation',
      home: Scaffold(

        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(119, 225, 225, 0.7019607843137254),
            Color.fromRGBO(110, 208, 114, 1.0),

          ],
        ),


      ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Container(
               margin: EdgeInsets.all(10),
               padding: EdgeInsets.all(10),
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
        title: Text("Attendee",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        onTap: (){
                attendee();
        },

      ),
             ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
            title: Text("Auteur",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Auteur()),);
            },

          ),),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
              child:ListTile(
                title: Text("Industrial",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Industrial()),);
                },

              ),),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
              child:ListTile(
                title: Text("Instructor",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Instructor()),);
                },

              ),),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
              child:ListTile(
                title: Text("Speaker",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Speaker()),);
                },

              ),),])
    )
        ),
      );

  }
}