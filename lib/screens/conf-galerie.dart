import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/Gallery.dart';
import 'package:foodybite_app/class/Speaker.dart';

import 'package:foodybite_app/class/conference.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class Galerie extends StatefulWidget {
  String id ;
  Galerie({Key? key,required this.id}) : super(key: key);

  @override
  State<Galerie> createState() => _MyAppStateSponsor();
}
class _MyAppStateSponsor extends State<Galerie> {

  bool favoritstatue=false;
  int long =0;

  bool isLoading = true;
  bool valid=false;

  List<Gallery> listgallerie=[];
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


  /* Future getparticipationid() async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Participants_Conference'));
    request.fields.addAll({
      'idConference': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Participants']);
        setState(() {
          long=data2.length;
          for(int i =0;i<long;i++){
            var id = data2[i]['pk'];
            searchspeaker(id);
          }

          isLoading = false;
        });
      }
      else {
        print(response.reasonPhrase);
      }

    }}
*/
  Future searchgallery( ) async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Gallerys_Conference'));
    request.fields.addAll({
      'idConference': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Gallerys']);
        if(mounted){
          setState(() {
            long=data2.length;
            for(int i=0;i<long;i++) {
              var id = data2[0]['pk'];
              var fields = json.encode(data2[0]['fields']);
              Gallery gallery = new Gallery(id, fields);
              listgallerie.add(gallery);

            }
            isLoading = false;});
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
  void initState() {
    searchgallery();
    getstatuefavorite();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Galerie',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
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
                    heroTag: "aa",
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
                    heroTag: "zz",
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
            :  ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: listgallerie.length,
          itemBuilder: (context, index) {
            return Container(
              height: 250,
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child:listgallerie[index].photo=='default_conference_photo.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/${listgallerie[index].photo}",width: 350,height: 250, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/gallery/${listgallerie[index].photo}",width:350,height: 250,fit: BoxFit.fill,),);



          }
      ),
      ),
    );


  }
}