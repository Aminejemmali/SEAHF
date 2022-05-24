import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(Speaker());
}


class Speaker extends StatefulWidget {

  @override
  State<Speaker> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Speaker> {
  TextEditingController Biography =TextEditingController();
  TextEditingController speechTitle =TextEditingController();
  TextEditingController abstractSubmissionText =TextEditingController();
  File? file1;
  bool valid=false;
  bool isLoading=true;
  Future getPdfAndUpload() async {

    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf','docx','pptx'], //here you can add any of extention what you need to pick
    );

    if(file != null) {

      setState(() {

        file1 = file;
        valid=true;
        isLoading=false;

      });

    }
  }
  Future speaker() async{
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    String? idconf = await prefs.getString('idconf');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Demande_Participant_Speaker'));
    request.fields.addAll({
      'idUser': iduser.toString(),
      'idConference': idconf.toString(),
      'Biography': Biography.text,
      'speechTitle': speechTitle.text,
      'abstractSubmissionText': abstractSubmissionText.text

    });
    request.files.add(await http.MultipartFile.fromPath('abstractSubmissionFile', file1!.path));


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
                          controller: Biography,


                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'Biography',

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
                        child: TextField(controller: speechTitle,


                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'speechTitle',

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
                        child:TextField(
                          controller: abstractSubmissionText,


                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'abstractSubmissionText',
                            hintMaxLines: 250,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),

                            ),
                          ),
                        )),
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
                        title:valid ?
                        Text(file1!.path.toString()):
                        Text("pick your file")
                        ,
                        onTap: (){
                          getPdfAndUpload();
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
                          onPressed: (){ speaker();},
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