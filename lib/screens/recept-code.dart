

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pallete.dart';
import '../widgets/background-image.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

class Code_Recept extends StatefulWidget  {
  @override
  State<Code_Recept> createState() => _Code_Recept();


}

class _Code_Recept extends State<Code_Recept> {
  late String email;
  TextEditingController code=TextEditingController();
  Future checkcode()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email=prefs.getString('email_code')!;
    print(email);
  var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/check_code'));
  request.fields.addAll({
  'email': email,
  'code': code.text
  });
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {

    var s=await response.stream.bytesToString();
    Map<String, dynamic> data1 =json.decode(s);
  if(data1['Reponse']=='True'){
      print('success');
      prefs.setString('code',code.text);

      Navigator.pushNamed(context, 'pass');
      }

    else {
      print('error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Code!!!!"),
      ));
    }
  }}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/final.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: Text(
              'Verif Code',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        'Please check that verification code ',
                        style: kBodyText,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                Container(
                  width:350,
                  child:
                    TextField(
                      controller: code,


                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(Icons.verified_user_rounded),
                        labelText: 'code',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),

                        ),
                      ),
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: ()=>checkcode(),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(210,65),
                          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          primary: Colors.blue),
                      child: const Text('Check'),
                    ),
                    SizedBox(
                      height:20,
                    ),

                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

