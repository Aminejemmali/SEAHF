import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodybite_app/class/user.dart';
import 'package:foodybite_app/pallete.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_loading/flutter_loading.dart';



class Payment extends StatefulWidget {
  String idconference , idparticipant;
  Payment({Key? key,required this.idconference,required this.idparticipant}) : super(key: key);


  State<Payment> createState() => _AccountUpdateState();
}
class _AccountUpdateState extends State<Payment> {

  late File image;
  Path? path;
  bool show=true;
  bool valid=false;
  int long =0;
   double price=0;
  bool isLoading = true;




  Future getprice() async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Get_Payment_Participant'));
    request.fields.addAll({
      'idParticipant': widget.idparticipant,
      'idConference': widget.idconference,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var s = await response.stream.bytesToString();
      Map<String, dynamic> data1 = json.decode(s);
      setState(() {
        if (data1['Reponse'] == 'Success') {

          if (data1['Price']==null){
            isLoading=false;
          }
          price=data1['Price'];
          isLoading=false;

        }
        else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title:'Error Connection' ,
            desc: data1['Reponse'],
            btnOkOnPress: () {},
          )..show();;
        }
      });
    }
  }
  Future payment( double price)async{
    var request = http.MultipartRequest('POST', Uri.parse('https://seahfwebserver.herokuapp.com/controllerlien/Insert_Payment'));
    request.fields.addAll({
      'idParticipant': widget.idparticipant,
      'price': price.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
        var s = await response.stream.bytesToString();
        Map<String, dynamic> data1 = json.decode(s);
        setState(() {
          if (data1['Reponse'] == 'Success') {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title:'done' ,
              desc: 'Done',
              btnOkOnPress: () {},
            )..show();
              }

        else if(data1['Reponse'] == 'Exist'){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title:'Error' ,
              desc: 'You have already send money',
              btnOkOnPress: () {},
            )..show();
    }
        });

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
   getprice();
    super.initState();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
        title: Text('Payment',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(32, 189, 154, 1.0) ,
      ),
      resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(133, 184, 219, 1.0),
              Color.fromRGBO(42, 164, 187, 1.0),
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
           ListView(
          children: [
                Column(
                  children: [
                    Container(
                      width:350,
                      child: Image.asset('assets/images/paypal.png'),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      TextField(


                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          labelText: "Card Number",


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
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

                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.mail),
                          labelText: "Card CVV",


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
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
                        enabled: false,


                        controller: TextEditingController()..text = price.toString(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.monetization_on),
                          labelText: "Price ",



                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),

                          ),
                        ),
                      ),),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width:350,
                      child:
                      ElevatedButton(
                        onPressed: (){
                          payment(price);

                          },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(210,65),
                            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.deepPurpleAccent),
                        child: const Text('Check out'),
                      ),),
                        SizedBox(
                          height: 25,
                        ),



                  ],
                )
              ],
            ),

      )


      );








  }}