import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(Industrial());
}


class Industrial extends StatefulWidget {

  @override
  State<Industrial> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Industrial> {
  TextEditingController nomindustrial =TextEditingController();
  TextEditingController exhibitionTitle =TextEditingController();
  Future industrial() async{
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    String? idconf = await prefs.getString('idconf');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Demande_Participant_Industrial'));
    request.fields.addAll({
      'idUser': iduser.toString(),
      'idConference': idconf.toString(),
      'nomIndustrial': nomindustrial.text,
      'exhibitionTitle': exhibitionTitle.text
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      setState(() {
        if (data1['Reponse'] == 'Success') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
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

                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(2,12,30, 1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(2, 5), // changes position of shadow
                  ),
                ],
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
                        child: TextField(
                          controller: nomindustrial,


                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'nomindustrial',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),

                            ),
                          ),
                        )
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
                        child: TextField(controller: exhibitionTitle,


                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'exhibitionTitle',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),

                            ),
                          ),)),
                    Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.blue,
                    Colors.blue,
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
              child:ElevatedButton(
                onPressed: (){ industrial();},
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(210,65),
                    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    primary: Colors.blue),
                child: const Text('Send'),
              )),
                  ])
          )
      ),
    );


  }}