import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
void main() {

}

class NotifPage extends StatefulWidget {


  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {


  bool isLoading = true;



  int long=0;

  List<Notif> listnotif=[];

  Future getnotif() async{
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Notifications'));
    request.fields.addAll({
      'idUser': iduser.toString()
    });


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){

        List data2 = json.decode(data1['Notifications']);
        if(mounted){
          setState(() {
             long =data2.length;
            for(int i=0;i<long;i++) {
              var id = data2[i]['pk'];
              var fields = json.encode(data2[i]['fields']);
              Notif notif = new Notif(id, fields);
              listnotif.add(notif);

            }
            isLoading = false;



          });}
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

  deletenotif(int id) async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Delete_Notification'));
    request.fields.addAll({
      'idNotification': id.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){


      }
    }
    else {
      print(response.reasonPhrase);
    }


  }
  void initState() {
    setState(() {

      getnotif();
    });}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
        title: Text('Notifications',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(70, 106, 226, 1.0) ,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(19,37,94, 1),
              Color.fromRGBO(83,104,157, 1),
            ],
          ),
        ),
        child:isLoading
            ?Center(
            child: SizedBox(

              height: 200,
              width: 200,
              child: SpinKitCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
                  );
                },
              ),
            )
        )
            :ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: long,
            itemBuilder: (context, index) {
              return Container(
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
                child:ListTile(
                  trailing: IconButton(onPressed:(){deletenotif(listnotif[index].id);}, icon: Icon(Icons.delete)),
                  title: Text(listnotif[index].Subject.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  subtitle: Text('Reply: ${listnotif[index].Body}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),


                ),
              );
            }
        ),
      ),

    );
  }
}