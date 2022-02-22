import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodybite_app/screens/forgot-password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pallete.dart';
import '../widgets/background-image.dart';
import '../widgets/rounded-button.dart';
import '../widgets/text-field-input.dart';
import 'package:http/http.dart' as http;

class Reset_Pass extends StatefulWidget  {
  @override
  State<Reset_Pass> createState() => _Reset_Pass();


}

class _Reset_Pass extends State<Reset_Pass> {

  TextEditingController pass=TextEditingController();
 late String email,code;
  Future <void> reset_pass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email=prefs.getString('email_code')!;
    code=prefs.getString('code')!;
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/reset_password'));
    request.fields.addAll({
      'email': email,
      'password': pass.text,
      'code': code
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 =json.decode(s);
      if(data1['Reponse']=='Success'){
        print('success');
        Navigator.pushNamed(context, 'Home');
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
                        'Type your new password ',
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
                      controller: pass,


                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(Icons.verified_user_rounded),
                        labelText: 'New password',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),

                        ),
                      ),
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: ()=>{reset_pass(),
                      },
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
