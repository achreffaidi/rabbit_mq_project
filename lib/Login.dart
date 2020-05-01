import 'package:flutter/material.dart';

import 'main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController ip = new TextEditingController();
  TextEditingController name = new TextEditingController();


  @override
  void initState() {

   setState(() {
     ip.text = "192.168.1.100" ;
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Login"),),
      body: Container(
        child : Center(child: Column(
         children: <Widget>[
           TextField(

             controller: ip,
             decoration: InputDecoration(
               hintText: "ip adress"
             ),
           ) ,
           TextField(
             controller: name,
             decoration: InputDecoration(
                 hintText: "name"
             ),
           ),
           RaisedButton(child: Text("Login"),onPressed: (){
             String _name  = name.text.toString() ;
             String _ip = ip.text.toString() ;
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => MyHomePage(_name,_ip)),
             );

           },)
         ],

        ),)
      ),


    );
  }
}
