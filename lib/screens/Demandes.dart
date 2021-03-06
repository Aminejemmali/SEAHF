import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/conference.dart';
import 'package:foodybite_app/screens/info-conf%C3%A9rence.dart';
import 'package:foodybite_app/screens/payment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
void main() {

}

class Demande extends StatefulWidget {


  @override
  State<Demande> createState() => _FavoriteState();
}

class _FavoriteState extends State<Demande> {
  List<String> listId=[];
  List<Conference> listConference=[];
  List<String> listReply=[];


  bool isLoading = true;


  Future getparticipant() async{
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Participations'));
    request.fields.addAll({
      'idUser': iduser.toString()
    });


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Participations']);
        if(mounted){
          setState(() {
            if(data2.isEmpty){
              isLoading=false;
            }

            long=data2.length;
            for(int i=0;i<long;i++){
              var id=json.encode(data2[i]['pk']);
              listId.add(id.toString());
              var idConferece = data2[i]['fields']['conference'];
              getconference(idConferece.toString());
              var reply= data2[i]['fields']['reply'];
              listReply.add(reply);
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
              isLoading=false;
            }



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

  deleteparticipation(int id) async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Delete_Participant'));
    request.fields.addAll({
      'idParticipant': listId[id]
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        listId.remove(id);
        listConferences.remove(id);
        listReply.remove(id);
      }
    }
    else {
      print(response.reasonPhrase);
    }


  }
  @override
  Widget build(BuildContext context) {
    getparticipant();
    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
        title: Text('Participations',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(32, 189, 154, 1.0) ,
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
              Color.fromRGBO(226, 223, 196, 1.0),
              Color.fromRGBO(154, 186, 229, 1.0),
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
                    colors: listReply[index]=="Accepted"?[
                      Color.fromRGBO(167, 227, 92, 0.7019607843137254),
                      Color.fromRGBO(119,148,225, 1),
                    ]:[
                      Color.fromRGBO(241, 88, 94, 0.7019607843137254),
                      Color.fromRGBO(229, 111, 172, 1.0),
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
                  trailing: IconButton(onPressed:(){deleteparticipation(index);}, icon: Icon(Icons.delete)),
                  leading:CircleAvatar( maxRadius: 50,child:listConferences[index].banner=='default_conference_banner.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/${listConferences[index].banner}",width: 100, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/banner/${listConferences[index].banner}",width: 100,fit: BoxFit.fill,),),
                  title: Text(listConferences[index].titleConference,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  subtitle: Text('Reply:${listReply[index]}',style: TextStyle(color: listReply[index]== "Accepted"? Colors.brown:Colors.black,fontWeight: FontWeight.bold),),
                  onTap: (){
                    if(listReply[index]=="Accepted"){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Payment(idconference: (this.listConferences[index].id).toString(), idparticipant: listId[index].toString())));}
                   else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(id: (this.listConferences[index].id).toString(),)));}


                  },


                ),
              );
            }
        ),
      ),

    );
  }
}