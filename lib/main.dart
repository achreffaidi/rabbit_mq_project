import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rabbit_mq_project/Login.dart';
import 'package:toast/toast.dart';

import 'API/MyMessage.dart';
import 'API/UserList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}




class MyHomePage extends StatefulWidget {


  String username ;
  String ip ;


  MyHomePage(this.username,
      this.ip); // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  _MyHomePageState createState() => _MyHomePageState(username,ip);
}

class _MyHomePageState extends State<MyHomePage> {


List<dynamic> listText = new List() ;

_MyHomePageState(this._username, this._ip);

String _username ;
String _ip ;

TextEditingController c1 = new TextEditingController() ;
List<Color> colors = [
  Colors.blue,
  Colors.redAccent,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.cyanAccent,
  Colors.pinkAccent,
  Colors.indigoAccent,
  Colors.teal,
  Colors.yellow,
  Colors.pinkAccent,
] ;

User user ;

@override
  void initState() {
    user = new User(_username , _ip);

    user.startListen((AmqpMessage message) {


       convertText(message.payloadAsString) ;

    setState(() {

    });
      message.reply("");
    });

    super.initState();
  }



  void convertText(String s ){
    print(s);


    MyMessage m =  MyMessage.fromJson(s);
    String text = m.text ;
    int p = m.change ;

    if(p==-2){
      user.loadUserList((UserList userList){

        listText = new List() ;
        for(UserListElement e in userList.userList){
          if(e.name != user.queueId) {
            listText.add({
              "text":"",
              "sender":e.name,
              "name":e.username

            });
            print(listText);
          }
          setState(() {

          });
          _sendMessage(c1.text.toString());
        }
      }) ;
     return ;
    }

if(text.isNotEmpty){
  int i = p-1 ;
  while(i>=0 && text[i]!=" ")i-- ;
  var x1 = text.substring(0,(i>0)?i+1:0);
  var x2 = text.substring((i>0)?i:0,text.length);
  text= x1+"<strong><a>"+x2 ;
  i = p+11 ;
  while(i<text.length && text[i]!=" ")i++ ;
  x1 = text.substring(0,(i>0)?i:0);
  x2 = text.substring((i>0)?i:0,text.length);
  text= x1+"</a></strong>"+x2 ;
}


    for(int i =0 ; i<listText.length ; i++){
      if(listText[i]["sender"]==m.sender){
        listText[i]["text"] = text ;
        setState(() {

        });

        break ;
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: AppBar(
        leading: null,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Cooperative Text App"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text("Input: " , style: TextStyle(fontSize: 30,color: Colors.deepPurple),),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Your Text ..."
                    ),
                    maxLines: 5,
                    controller:c1 ,
                    onChanged: (val){

                         _sendMessage(val);
                    },
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Container(
                color: Colors.indigoAccent,
                height: 600,
                child: new ListView.builder
                  (
                    itemCount: listText.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildListItem(listText[index],index),
                        ),
                      ) ;
                    }
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          user.delete();
          Navigator.of(context).pop();
        },
        tooltip: 'Increment',
        child: Icon(Icons.exit_to_app),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


   Widget  buildListItem(item , index){
  return
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.supervised_user_circle , color: colors[index%colors.length],size: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item["name"] , style: TextStyle(fontSize: 20 , color: colors[index%colors.length] ),),
              ),
            ],
          ) ,
          Card(child: HtmlWidget(item["text"].isEmpty?"\n\n\n":item["text"],hyperlinkColor: colors[index%colors.length],))
        ],
      );


   }

    @override
  void dispose() {
    user.disconnect();
    super.dispose();
  }

  void _sendMessage(String val) {
    String s = json.encode({
      "name":user.name,
      "text":val,
      "change":c1.value.selection.baseOffset,
      "sender":user.queueId
    });
    user.sendMessage(s);
  }


}



class User {

  String queueId ;
  String name;
  ConnectionSettings settings ;
  Client client ;
  String baseUrl ;

  UserList userList ;

  User(this.name , this.baseUrl){

    settings  =  new ConnectionSettings(host: baseUrl,authProvider: PlainAuthenticator("aaa", "aaa")) ;
    client = new Client(settings : settings);
  }


  Future<void> loadUserList(callback) async {

    http.get("http://"+baseUrl+":8080/users").then((http.Response response){

      print(response.body);
      userList  = UserList.fromJson(response.body);
      callback(userList) ;
    });

  }

  Channel channel ;
  Exchange exchange ;
  Consumer consumer ;

  void disconnect(){
    consumer.cancel();
    channel.close();
  }
  void startListen(callBack) async {
    Client client = new Client(settings: settings);


    channel = await client.channel();
    exchange = await channel.exchange("notifier", ExchangeType.FANOUT);
    consumer = await exchange.bindPrivateQueueConsumer(null);
    consumer.listen(callBack);
    queueId = consumer.queue.name ;


          http.post("http://"+baseUrl+":8080/users" ,
              
              body: json.encode(
                  {"name":consumer.queue.name ,
                  "username":name}) ,
            headers: {
            "Content-Type":"application/json"
            }
          ).then((http.Response response){
            print(response.body);
          });

  }

  void sendMessage(String s ) async {

    print(s);
    if(s.isEmpty) s=" ";
    client
        .channel()
        .then((Channel channel) => channel.exchange("notifier", ExchangeType.FANOUT,durable: false))
        .then((Exchange exchange) {
      // We dont care about the routing key as our exchange type is FANOUT
      exchange.publish(s,"");
      return client.close();
    });

  }

  void delete() {
    for(UserListElement e in userList.userList){
      if(e.name==queueId){
        http.delete("http://"+baseUrl+":8080/users/"+e.id).then((http.Response response){
          print(response.body) ;
        });
      }
    }




  }





  /*
  (AmqpMessage message) {
      // Get the payload as a string
      print(" [x] Received string: ${message.payloadAsString}");
      // The message object contains helper methods for
      // replying, ack-ing and rejecting
      message.reply("world");
    }

   */

}
