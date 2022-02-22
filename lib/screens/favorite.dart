import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/conference.dart';
import 'package:foodybite_app/screens/info-conf%C3%A9rence.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
void main() {

}

class Favorite extends StatefulWidget {


  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool isLoading = true;
  Future getfavorite() async{
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Favorites'));
    request.fields.addAll({
      'idUser': iduser.toString()
    });


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Favorite']);
        if(mounted){
          setState(() {
            long=data2.length;
            for(int i=0;i<long;i++){
            var id = json.encode(data2[i]['fields']['conference']);
             getconference(id.toString());
            };



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
   int long=0;
  List<Conference> listConferences=[];
  Future getconference(String id) async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_Conference'));
    request.fields.addAll({
      'idConference': id
    });


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Conference']);
        if(mounted){
          setState(() {

            var id = data2[0]['pk'];
            var fields = json.encode(data2[0]['fields']);
            Conference conferance = new Conference(id, fields);
            listConferences.add(conferance);
            if(listConferences.length==long){
              isLoading=false;}



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
  @override
  Widget build(BuildContext context) {
    getfavorite();
    return Scaffold(
        appBar: AppBar(
          actions: [

          ],
          title: Text('Favorite',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(19,37,94, 1) ,
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
                    leading:CircleAvatar( maxRadius: 50,child:listConferences[index].banner=='default_conference_banner.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/${listConferences[index].banner}",width: 100, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/banner/${listConferences[index].banner}",width: 100,fit: BoxFit.fill,),),
                    title: Text(listConferences[index].titleConference,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    subtitle: Text('Statute: ${listConferences[index].statutConference}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(id: (this.listConferences[index].id).toString(),)));
                    },

                  ),
                );
              }
          ),
        ),

    );
  }
}