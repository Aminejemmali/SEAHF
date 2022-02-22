// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:foodybite_app/class/user.dart';
import 'package:foodybite_app/screens/Demandes.dart';
import 'package:foodybite_app/screens/chatbot.dart';
import 'package:foodybite_app/screens/conference.dart';

import 'package:http/http.dart' as http;
import 'package:foodybite_app/screens/favorite.dart';
import 'package:foodybite_app/screens/notifications.dart';
import 'package:foodybite_app/screens/profil.dart';

import 'package:foodybite_app/screens/update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background-image.dart';

void main() {
  runApp(const Home());
}

class  Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   String? username="";
   String? usermail="";



  getData() async {
    final prefs = await SharedPreferences.getInstance();
     username = await prefs.getString('username');
     usermail = await prefs.getString('usermail');
  }

  int currentIndex=0;
  final screens =[
    ConferencesPage(),
    Favorite(),
    Demande(),
    NotifPage(),




  ];
  clearshare() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(

     body : screens[currentIndex],
     bottomNavigationBar: BottomNavigationBar(
       selectedItemColor: Colors.white,
         backgroundColor:   Color.fromRGBO(19,37,94, 1),
       currentIndex: currentIndex,
       onTap: (index) => setState(() => currentIndex=index),
       items: [
         BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',

         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.favorite),
             label: 'favorite',
             backgroundColor:   Color.fromRGBO(19,37,94, 1),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.send),
           label: 'Demandes',
           backgroundColor:   Color.fromRGBO(19,37,94, 1),
         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.notifications),
             label: 'notifications',
             backgroundColor:   Color.fromRGBO(19,37,94, 1),
         ),
         ]

     ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/images/user_avavtar.png'),),
                accountName: Text(username!),
                accountEmail:  Text(usermail!)),
            ListTile(
              title: Text("Profil manager"),
              leading: Icon(Icons.account_circle_rounded) ,
              onTap:() {
              Navigator.pushReplacementNamed(context, 'profil');}),
            ListTile(
                title: Text("Need Help ?"),
                leading: Icon(Icons.help) ,
                onTap:() {
                  Navigator.pushReplacementNamed(context, 'contact');}),
            ListTile(
                title: Text("Log out "),
                leading: Icon(Icons.logout) ,
                onTap:()  {
                    getData();
                  Navigator.pushReplacementNamed(context, 'Home');}),
          ],
        ),
      ),
    );



  }
}
