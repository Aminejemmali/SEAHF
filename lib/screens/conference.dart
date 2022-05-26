
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/class/Gallery.dart';
import 'package:foodybite_app/class/conference.dart';
import 'package:foodybite_app/screens/info-conf%C3%A9rence.dart';
import 'package:http/http.dart' as http;

import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:seahf_admin_app/classes/gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConferencesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ConferencesPageState();
  }
}
class ConferencesPageState extends State<ConferencesPage>{
  int longConferences =0;
  int longGallery =0;
  int indexPage=2;
  List<Conference> listConferences=[];
  List<Gallery> listGallery=[];
  ScrollController _scrollController = new ScrollController();

  Future GetAll_Gallery() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Gallery'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Gallerys']);
        setState(() {
          longGallery =data2.length;
          for(int i=0;i<longGallery;i++) {
            var id = data2[i]['pk'];
            var fields = json.encode(data2[i]['fields']);
            Gallery gallery = new Gallery(id, fields);
            listGallery.add(gallery);
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
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
          buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
          btnOkText: 'Ok',
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
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
        buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )..show();
    }
  }

  Future getData() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Conference'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Conferences']);
        if(mounted){
        setState(() {
          longConferences =data2.length;
          for(int i=0;i<longConferences;i++) {
            var id = data2[i]['pk'];
            var fields = json.encode(data2[i]['fields']);
            Conference conferance = new Conference(id, fields);
            listConferences.add(conferance);
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
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
          descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
          buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
          btnOkText: 'Ok',
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
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900,),
        descTextStyle: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w900,),
        buttonsTextStyle:TextStyle(color: Colors.black,fontSize: 15),
        btnOkText: 'Ok',
        btnOkOnPress: () {},
      )..show();
    }
  }


  @override
  void initState() {
    setState(() {

      getData();
      GetAll_Gallery();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: search(listConferences));

          }, icon: Icon(Icons.search))
        ],
        title: Text('Conferences',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(32, 189, 154, 1.0) ,
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
          child:ListView(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 150,
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: longGallery,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        height: 150,
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
                        child:listGallery[index].photo=='default_conference_photo.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/${listGallery[index].photo}",width: 120,height: 100, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/gallery/${listGallery[index].photo}",width:120,height: 100,fit: BoxFit.fill,),);

                    }
                ),
              ),
              Container(
                height:500 ,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: longConferences,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(64, 93, 238, 0.7019607843137254),
                                Color.fromRGBO(120, 153, 238, 1.0),
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
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              listConferences[index].banner=='default_conference_banner.jpg'?Image.network("https://seahfwebserver.herokuapp.com/media/default_conference_banner.jpg",height:70,width: 100, fit: BoxFit.fill,):Image.network("https://seahfwebserver.herokuapp.com/media/banner/${listConferences[index].banner}",width: 200,fit: BoxFit.fill,),
                              Text(listConferences[index].titleConference,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              Text('Statute: ${listConferences[index].statutConference}',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
                              Text('Date: ${listConferences[index].dateConference}',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),

                            ],
                          ),

                        ),
                        onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(id: (this.listConferences[index].id).toString(),)));
                        },
                      );
                    }
                ),
              ),
            ],
          )
      ),
    );
  }

}
class search extends SearchDelegate {

  List<Conference> listConferences=[];
  search(List<Conference> list){
    listConferences=list;
  }


  Future getData() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/GetAll_Conference'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s=await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      if(data1['Reponse']=='Success'){
        List data2 = json.decode(data1['Conferences']);
          var longConferences =data2.length;
          for(int i=0;i<longConferences;i++) {
            var id = data2[i]['pk'];
            var fields = json.encode(data2[i]['fields']);
            Conference conferance = new Conference(id, fields);
            listConferences.add(conferance);
          }
      }}}

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed:(){
        query="";
      }, icon: Icon(Icons.close))
      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return
      IconButton(onPressed:(){
        close(context, null);
      }, icon: Icon(Icons.arrow_back));


  }

  @override
  Widget buildResults(BuildContext context) {
           return Text("null") ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {

   List filtreliste= listConferences.where((element) => element.titleConference.contains(query) ).toList();
    return ListView.builder(
        itemCount: query=="" ? 1:1,
    itemBuilder :(context,index){
          return  Container(
            padding: EdgeInsets.all(10),
             child: query==""?
             ListTile(
            title:Text( listConferences[index].titleConference ,
             style: TextStyle(fontSize: 25),),
                 onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(id: (listConferences[index].id).toString(),)));
    },):
             ListTile(
            title: Text( filtreliste[index].titleConference ,
               style: TextStyle(fontSize: 25),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(id: (filtreliste[index].id).toString(),)));
            },));
    }) ;
  }

}