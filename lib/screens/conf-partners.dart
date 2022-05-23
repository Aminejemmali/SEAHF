import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/Speaker.dart';
import 'package:foodybite_app/class/Supporter.dart';

import 'package:foodybite_app/class/conference.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class Partner extends StatefulWidget {
  String id ;
  Partner({Key? key,required this.id}) : super(key: key);

  @override
  State<Partner> createState() => _MyAppStateSponsor();
}
class _MyAppStateSponsor extends State<Partner> {

  bool favoritstatue=false;
  int long =0;
  List<Supporter> listsupporter=[];
  bool isLoading = false;
  bool valid=false;


  String? username;
  late String idpar;

  Future favorite() async {
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');


    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/AddDelFavorite'));
    request.fields.addAll({
      'idUser': iduser.toString(),

      'idConference': widget.id

    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      setState(() {
        if (data1['Reponse'] == 'Add') {
          favoritstatue = true;
        }
        else if (data1['Reponse'] == 'Del') {
          favoritstatue = false;
        }
        else {
          print("faild");
        }
      });
    }
  }

  Future getstatuefavorite() async {
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    var request = http.MultipartRequest('POST', Uri.parse(
        'https://seahfwebserver.herokuapp.com/controllerlien/GetStatutFavorite'));
    request.fields.addAll({
      'idUser': iduser.toString(),
      'idConference': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      setState(() {
        if (data1['Reponse'] == 'Exist') {
          favoritstatue = true;
        }
        else if (data1['Reponse'] == 'Not Exist') {
          favoritstatue = false;
        }
        else {
          print("faild");
        }
      });
    }
  }

  Future sendparticipantcoor( String idconf) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idconf', idconf);
    Navigator.pushNamed(context, 'partici');
  }


  Future getpartnerid() async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Partner_Conference'));
    request.fields.addAll({
      'idConference': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Partners']);
        setState(() {
          long=data2.length;
          for(int i =0;i<long;i++){
            var id = data2[i]['fields']['supporter'];
            searchsponsor(id);
          }

          isLoading = false;
        });
      }
      else {
        print(response.reasonPhrase);
      }

    }}

  Future searchsponsor(int id) async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_Supporter'));
    request.fields.addAll({
      'idSupporter': id.toString(),
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        // username = json.decode(data1['Name_Speaker']);
        List data2 = json.decode(data1['Supporter']);
        if(mounted){
          setState(() {
            var id = data2[0]['pk'];
            var fields = json.encode(data2[0]['fields']);
            Supporter supporter = new Supporter(id, fields);
            listsupporter.add(supporter);
            isLoading = false;
          });
        }
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
  void initState() {

getpartnerid();
    getstatuefavorite();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(


        title: Text('Partner',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(32, 189, 154, 1.0) ,
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0,),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                  margin: EdgeInsets.all(2.5),
                  child: FloatingActionButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        desc: 'Are you sure about adding to this conference ?',
                        descTextStyle: TextStyle(color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,),
                        buttonsTextStyle: TextStyle(color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,),
                        btnOkText: 'Yes',
                        btnOkOnPress: () {
                          sendparticipantcoor((widget.id));
                          /*print(widget.id);
                          print(this.listConferences[0].id);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Participation(idser:widget.id,idconf: (this.listConferences[0].id).toString(),)));
                        */
                        },
                        btnCancelText: 'Cancel',
                        btnCancelOnPress: () {},
                      )
                        ..show();
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.red,
                    elevation: 10,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.5),
                  child: FloatingActionButton(
                    onPressed: () {
                      favorite();
                    },
                    child:favoritstatue==true
                        ?Icon(Icons.favorite)
                        :Icon(Icons.favorite_border),
                    backgroundColor: Colors.red,
                    elevation: 10,
                  ),
                ),
              ],
            ),
          )
      ),
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(142, 158, 171, 1),
              Color.fromRGBO(238, 242, 243, 1),
            ],
          ),
        ),

        child:
        isLoading
            ?Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: SpinKitCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            )
        )
            :ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: listsupporter.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(48, 132, 227, 1.0),
                      Color.fromRGBO(154, 186, 229, 1.0),
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
                  leading:CircleAvatar( maxRadius: 50,child:listsupporter[index].logosuppoter=='default_logo_supporter.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/${listsupporter[index].logosuppoter}",width: 100, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/logo_supporter/${listsupporter[index].logosuppoter}",width: 100,fit: BoxFit.fill,),),

                  title: Text(listsupporter[index].titlesupporter,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  subtitle: Text('Biography: ${listsupporter[index].phonesupporter}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),


                ),
              );
            }
        ),
      ),
    );


  }
}