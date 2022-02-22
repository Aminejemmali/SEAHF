import 'package:flutter/material.dart';
import 'package:foodybite_app/pallete.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const Notifications());
}

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextEditingController email = TextEditingController();
  TextEditingController Subject = TextEditingController();
  TextEditingController body = TextEditingController();

  Future <void> Conatct(String  mail, subject,body) async {
    Map data = {
      'email':mail,
      'subject':subject,
      'body':body,
    };
    print(data);
    var response = await http.post(Uri.parse("https://seahfwebserver.herokuapp.com/controllerlien/contactAdmin"),

      body: data,
      headers: {
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if ((response.body).contains("Received")) {

      print('success');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Done"),));
    } else {
      print('error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something wrong!!!!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: 110,
                ),
                Column(

                  children: [


                    Container(
                      width:350,
                      child:
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.mail),
                          labelText: ' mail',
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
                        controller: Subject,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.subject),
                          hintText: 'Subject',
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
                      color: Colors.white,
                      child:
                      TextField(
                        controller: body,


                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(Icons.content_copy_outlined),
                          labelText: 'Body',
                          contentPadding: const EdgeInsets.symmetric(vertical: 100),


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),

                          ),
                        ),
                      ),),
                    SizedBox(
                      height: 25,
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width:350,
                      child:
                      ElevatedButton(
                        onPressed: ()=>Conatct(email.text, Subject.text, body.text),

                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(210,65),
                            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.deepPurpleAccent),
                        child: const Text('Send'),
                      ),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: kBodyText,
                        ),

                      ],
                    ),

                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}