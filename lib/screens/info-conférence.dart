import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



import 'package:foodybite_app/class/conference.dart';
import 'package:foodybite_app/screens/Commit.dart';
import 'package:foodybite_app/screens/Topics.dart';
import 'package:foodybite_app/screens/conf-galerie.dart';
import 'package:foodybite_app/screens/conf-partners.dart';
import 'package:foodybite_app/screens/conf-speaker.dart';
import 'package:foodybite_app/screens/conf-sponsor.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class Details extends StatefulWidget {
  String id ;
   Details({Key? key,required this.id}) : super(key: key);

  @override
  State<Details> createState() => _MyAppState();
}
class _MyAppState extends State<Details> {
  bool favoritstatue=false;
  int long =0;
  bool isLoading = true;
  bool valid=false;
  List<Conference> listConferences=[];
  Future getData() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_Conference'));
    request.fields.addAll({
      'idConference': widget.id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Conference']);
        if(mounted){
          setState(() {
            long=data2.length;
            var id = data2[0]['pk'];
            var fields = json.encode(data2[0]['fields']);
            Conference conferance = new Conference(id, fields);
            listConferences.add(conferance);
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
  Future favorite() async {
    final prefs = await SharedPreferences.getInstance();
    String? iduser = await prefs.getString('iduser');
    print(iduser.toString());
    print(widget.id);
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
      if(mounted){
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
    }}
  }
Future sendparticipantcoor( String idconf) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('idconf', idconf);
  Navigator.pushNamed(context, 'partici');
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
  getData();
  getstatuefavorite();
    super.initState();
  }
    @override
    Widget build(BuildContext context) {


      return Scaffold(
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
                            sendparticipantcoor((this.listConferences[0].id).toString());
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
                      heroTag: "bb",
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
                :
             ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: long,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    //Logo Supporter
                    InkWell(
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(119, 148, 225, 0.7),
                              Color.fromRGBO(119, 148, 225, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(2, 12, 30, 1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(
                                  2, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.network(listConferences[0].banner ==
                            'default_conference_banner.jpg'
                            ? "https://seahfwebserver.herokuapp.com/media/default_conference_banner.jpg"
                            : "https://seahfwebserver.herokuapp.com/media/banner/${listConferences[index]
                            .banner}", fit: BoxFit.fill,),
                      ),

                    ),
                    //Title Supporter
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Title Supporter:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons.title,
                            color: Colors.white,)),
                          subtitle: Text(listConferences[0].titleConference,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)
                      ),
                    ),
                    //dates
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Date conference:', style: TextStyle(color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .home_sharp, color: Colors.white,)),
                          subtitle: Text(listConferences[0].dateConference,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //datepaper
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Last Date Paper:', style: TextStyle(color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .home_sharp, color: Colors.white,)),
                          subtitle: Text(listConferences[0].lastdatepaper,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //daterevision
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Last Date Revision:', style: TextStyle(color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .home_sharp, color: Colors.white,)),
                          subtitle: Text(listConferences[0].lastdaterevision,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //datefinal
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            ' Date Final Paper:', style: TextStyle(color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .home_sharp, color: Colors.white,)),
                          subtitle: Text(listConferences[0].latedatefinalpapier,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //Address01
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Address01:', style: TextStyle(color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .home_sharp, color: Colors.white,)),
                          subtitle: Text(listConferences[0].address01,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //Country
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(119, 148, 225, 0.7),
                              Color.fromRGBO(119, 148, 225, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(2, 12, 30, 1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(
                                  2, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                            title: Text(
                              'Country:', style: TextStyle(color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),),
                            leading: Container(
                                height: double.infinity, child: Icon(Icons
                                .home_sharp, color: Colors.white,)),
                            subtitle: Text(listConferences[0].country,
                              style: TextStyle(color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),)
                        )

                    ),
                    //State
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(119, 148, 225, 0.7),
                              Color.fromRGBO(119, 148, 225, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(2, 12, 30, 1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(
                                  2, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                            title: Text('State:', style: TextStyle(color: Colors
                                .white, fontSize: 17, fontWeight: FontWeight
                                .bold),),
                            leading: Container(
                                height: double.infinity, child: Icon(Icons
                                .home_sharp, color: Colors.white,)),
                            subtitle: Text(listConferences[0].city,
                              style: TextStyle(color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),)
                        )

                    ),
                    //Coordinates
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Coordinates:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons.map,
                            color: Colors.white,)),
                          subtitle: Text(listConferences[0].coordinates,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //SCOPE
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('SCOPE:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text(listConferences[0].SCOPE,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //More Information
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'More Information:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .info_outline_rounded, color: Colors.white,)),
                          subtitle: Text(listConferences[0].moreInformation,
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //prixspeaker
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('Speaker price:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text((listConferences[0].prixspeaker).toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //prixauteur
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('Auteur price:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text((listConferences[0].prixauteur).toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //prixinstructor
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('Instructor price:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text((listConferences[0].prixinstructor).toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //prixinductrial
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('Industrial price:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text((listConferences[0].prixindustrial).toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //prixattendue
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text('Attendee price:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .text_snippet, color: Colors.white,)),
                          subtitle: Text((listConferences[0].prixattendee).toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //NumPlace
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(119, 148, 225, 0.7),
                            Color.fromRGBO(119, 148, 225, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(2, 12, 30, 1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(2, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(
                            'Number Place:', style: TextStyle(color: Colors
                              .white, fontSize: 17, fontWeight: FontWeight
                              .bold),),
                          leading: Container(
                              height: double.infinity, child: Icon(Icons
                              .event_seat, color: Colors.white,)),
                          subtitle: Text(listConferences[0].numPlace.toString(),
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),)

                      ),
                    ),
                    //statutConference
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(119, 148, 225, 0.7),
                              Color.fromRGBO(119, 148, 225, 1),

                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(2, 12, 30, 1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(
                                  2, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                            title: Text('Statut Conference:',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),),
                            leading: Container(
                                height: double.infinity, child: Icon(Icons
                                .home_sharp, color: Colors.white,)),
                            subtitle: Text(listConferences[0].statutConference,
                              style: TextStyle(color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),)
                        )

                    ),
                    //speaker
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Moreinformations(id: widget.id)),),),
                        title: Text("Speakers",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                      ),),
                    //sponsor
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Sponsor(id: widget.id)),),),
                        title: Text("Sponsors",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),


                      ),),
                    //partners
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Partner(id: widget.id)),),),

                        title: Text("Partners",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),


                      ),),
                    //galerie
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Galerie(id: widget.id)),),),

                        title: Text("Galerie",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                      ),),
                    //topic
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Topic(id: widget.id)),),),
                        title: Text("Topics",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),


                      ),),
                    //commit
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(100, 201, 56, 0.7019607843137254),
                            Color.fromRGBO(15, 109, 89, 1.0),
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
                        trailing: IconButton(icon: Icon(Icons.send_and_archive_sharp), onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Commit(id: widget.id)),),),
                        title: Text("Commit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),


                      ),),
                  ],
                );
              }
          ),
        ),

      );
    }
  }