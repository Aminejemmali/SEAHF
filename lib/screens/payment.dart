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



class Payment extends StatefulWidget {


  State<Payment> createState() => _AccountUpdateState();
}
class _AccountUpdateState extends State<Payment> {

  late File image;
  Path? path;
  bool show=true;
  bool valid=false;
  int long =0;

  bool isLoading = true;







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

    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
        title: Text('Payment',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(32, 189, 154, 1.0) ,
      ),
      resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(133, 184, 219, 1.0),
              Color.fromRGBO(42, 164, 187, 1.0),
            ],
          ),
        ),
          child: ListView(
          children: [



                Column(

                  children: [


                    Container(
                      width:350,
                      child:
                      TextField(


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