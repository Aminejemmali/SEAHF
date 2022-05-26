import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodybite_app/class/country.dart';
import 'package:foodybite_app/class/state.dart';
import 'package:foodybite_app/screens/login-screen.dart';
import '../pallete.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}
class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController user = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addresse = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  bool show = true;
  var total_Countries=250;
  var idCountry=0;
  var idState=0;
  var selectedCountry="Select Country";
  var selectedStates="Select State";
  var listCountry=[];
  late var listStates=[];
  getCoutry() async{
    final String res = await rootBundle.loadString('assets/sample.json');
    final d1 = await json.decode(res);
    setState(() {
      for(int j=0;j<total_Countries;j++){
        var n=d1[j]['name'];
        Country c=new Country(j, n);
        listCountry.add(c);
      }
    });


  }

  getState(int y) async{
    final String res = await rootBundle.loadString('assets/sample.json');
    final d1 = await json.decode(res);
    final d2 = d1[y] as Map;
    final d3 = d2["states"];
    int l=d3.length;
    for(int j=0;j<l;j++){
      var n=d1[y]['states'][j]['name'];
      States s=new States(j, n);
      listStates.add(s);
    }
  }

  Future <void> register() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Insert_User'));
    request.fields.addAll({
      'username': user.text,
      'email': mail.text,
      'phone': phone.text,
      'password': pass.text,
      'dateBirth': date.text,
      'address01': addresse.text,
      'country': country.text,
      'city': city.text
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if (data1['Reponse'] == 'Success') {
        //Or put here your next screen using Navigator.push() method
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title:'Welcome' ,
          desc: data1['IN SEAHF'],
          btnOkOnPress: () {},
        )..show();
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
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/final.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Center(
                        child: new Image.asset('assets/images/seahf.png'),

                      ),
                    ),
                  ], ),
                Column(
                  children: [
                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: user,




                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.supervised_user_circle),
                          labelText: 'Username',


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
                        controller: pass,
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
                      ),),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: date,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.date_range),
                          labelText: 'Birth date',

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

                        controller: addresse,


                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.home),
                          labelText: 'Addresse',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //city
                    Container(
                      width:350,
                      child:
                      TextField(

                        controller: country,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.location_city),
                          labelText: 'country',

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

                        controller: city,


                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.location_city),
                          labelText: 'city',

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
                        controller: phone,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Phone',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),),),),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      ElevatedButton(
                        onPressed: ()=>register(),

                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(210,65),
                            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.blue),
                        child: const Text('Register'),
                      ),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "Home");
                          },
                          child: Text(
                            'Login',
                            style: kBodyText.copyWith(
                                color: kBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );

  }
}
