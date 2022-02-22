import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/chatbot.dart';
import 'package:foodybite_app/screens/contactadmin.dart';
import 'package:foodybite_app/screens/favorite.dart';
import 'package:foodybite_app/screens/home.dart';
import 'package:foodybite_app/screens/info-conf%C3%A9rence.dart';
import 'package:foodybite_app/screens/participation.dart';
import 'package:foodybite_app/screens/profil.dart';

import 'package:foodybite_app/screens/recept-code.dart';
import 'package:foodybite_app/screens/reset_password.dart';
import 'package:foodybite_app/screens/update.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(
          seconds: 5,
          navigateAfterSeconds:LoginScreen(),
          title: new Text(
            'Welcome in SEAHF',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          image: new Image.asset('assets/images/seahf.png'),
          photoSize: 100.0,
          backgroundColor: Colors.blue,
          styleTextUnderTheLoader: new TextStyle(),
          loaderColor: Colors.white
      ),

      routes: {

        'ForgotPassword': (context) => ForgotPassword(),
        'CreateNewAccount': (context) => CreateNewAccount(),
        'Home':(context)=> LoginScreen(),
        'code':(context)=> Code_Recept(),
        'Home1':(context)=>Home(),
        'pass':(context)=>Reset_Pass(),
        'partici':(context)=>Participation(),
        'profil':(context)=>Profilupdate(),
        'favorite':(context)=>Favorite(),
        'Notification':(context)=>NotifPage(),
        'contact':(context)=>ContactPage(),

      },
    );
  }
}
