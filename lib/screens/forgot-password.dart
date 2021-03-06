import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodybite_app/screens/recept-code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pallete.dart';
import '../widgets/background-image.dart';
import '../widgets/rounded-button.dart';
import '../widgets/text-field-input.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController e_mail=TextEditingController();
  Future <void> post_mail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/forgot_password'));
  request.fields.addAll({
  'email': e_mail.text
  });
  http.StreamedResponse response = await request.send();
    var s=await response.stream.bytesToString();
    Map<String, dynamic> data1 = json.decode(s);
    if(data1['Reponse']=='Received'){
      prefs.setString('email_code',e_mail.text);
          Navigator.pushNamed(context, 'code');
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
              'Forgot Password',
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
                        'Enter your email we will send instruction to reset your password',
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
                      controller: e_mail,


                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(Icons.mail),
                        labelText: 'mail',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),

                        ),
                      ),
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: ()=>{post_mail(),
                     },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(210,65),
                          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          primary: Colors.blue),
                      child: const Text('Send'),
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
