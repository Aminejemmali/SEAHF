import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';



import 'package:shared_preferences/shared_preferences.dart';
import '../pallete.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
TextEditingController mail =TextEditingController();
TextEditingController password =TextEditingController();
bool show=true;
late int id;
int long=0;
Future conx(String  mail, pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var request = http.MultipartRequest('POST',
      Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/loginUser'));
  request.fields.addAll({
    'email': mail,
    'password':pass,
  });
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    var s=await response.stream.bytesToString();
    Map<String, dynamic> data1 = json.decode(s);
    if(data1['Reponse']=='Success'){
      List data2 = json.decode(data1['user']);
      
        setState(() {

          if(data2[0]['fields']['statutUser']=='Activated'){


            long =data2.length;
            id = data2[0]['pk'];
            print(id.toString());
            prefs.setString('iduser', id.toString());
            prefs.setString('username', data2[0]['fields']['username']);
            print(data2[0]['fields']['username']);
            prefs.setString('usermail', data2[0]['fields']['email']);
            print(data2[0]['fields']['email']);
            Navigator.pushReplacementNamed(context, 'Home1');

          }
        });

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



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/vert.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                      child: new Image.asset('assets/images/seahf.png'),

                  ),
                ),
              Column(

                children: [
                  Container(
                    width:350,
                      child:
                  TextField(
                    controller: mail,


                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(Icons.mail),
                      labelText: 'mail',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),

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
                    controller: password,
                    obscureText: show,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                         suffix: InkWell(
                           child: Text('Show'),
                            onTap:(){
                             setState(() {
                                 show=!show;
                              });}),
                    ),
                  ),
                    ),
                    Container(
                    width:350,
                      alignment: Alignment.centerRight,
                   child:
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Text(
                      'Forgot Password',
                      style: kBodyText,
                    ),
                  ),),
                  SizedBox(
                    height: 25,
                  ),

                  Container(
                   width:350,
                    child:
                  ElevatedButton(
              onPressed: (){ conx(mail.text,password.text);},
             style: ElevatedButton.styleFrom(
                        fixedSize: const Size(210,65),
                        textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        primary: Colors.blue),
                    child: const Text('Login'),
                  ),),

                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'CreateNewAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );

  }

}
