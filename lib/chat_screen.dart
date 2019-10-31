import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

TextEditingController controller = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  bool isMe = true;

  @override
  void initState() {
    //getMessages();
    getMessageStream();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String message = '⚬⚬⚬⚬⚬⚬⚬';
  String user = '...';
  List <Widget> widgetList = [];
  Random random = new Random();
//  void getMessages() async {
//    widgetList = [];
//    QuerySnapshot collectionData =
//        await Firestore.instance.collection('messages').getDocuments();
//    for (DocumentSnapshot messages in collectionData.documents) {
//      print(messages.data);
//      widgetList.add(Bubble(
//        message: '${messages.data['text']}',
//        time: '${messages.data['sender']}',
//        delivered: true,
//        isMe: random.nextBool(),
//      ),);
//
//    }
//    setState(() {
//
//    });
//  }

  void getMessageStream () async{
    widgetList = [];
    await for(var snapshot in Firestore.instance.collection('messages').snapshots()){
      for (var message in snapshot.documents){
        String text = message.data['text'];
        String sender = message.data['sender'];
        print ('$text by $sender');
        widgetList.add(Bubble(
          message: '${message.data['text']}',
          time: '${message.data['sender']}',
          delivered: true,
          isMe: isMe,

        ),);
        setState(() {

        });
      }
    }
  }

  Future messageStream () async{
    widgetList = [];
    await for(var snapshot in Firestore.instance.collection('messages').snapshots()){
      for (var message in snapshot.documents){
        String text = message.data['text'];
        String sender = message.data['sender'];
        print ('$text by $sender');
        widgetList.add(Bubble(
          message: '${message.data['text']}',
          time: '${message.data['sender']}',
          delivered: true,
          isMe: isMe,

        ),);
        setState(() {

        });
      }
    }
  }


  Future lastMessages() async {
    QuerySnapshot collectionData = await Firestore.instance.collection('messages').getDocuments();
    print ('enters last message');
    setState(() {
      message = collectionData.documents.last['text'];
      user = collectionData.documents.last['sender'];
    });
  }

  @override
  Widget build(BuildContext context) {

    //bool isMe = true;

       String chat;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          '⚡ Chat',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.white,
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              controller.dispose();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
              icon: Icon(Icons.file_download),
              color: Colors.white,
              onPressed: null,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widgetList,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: TextField(
                      controller: controller,
                      onChanged: (x) {
                        chat = x;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: controller.text.isEmpty ? null : sendMessage,

                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

  sendMessage() async {
    await Firestore.instance.collection('messages').add({
      'sender': user,
      'text': controller.text,
    });
    controller.clear();
    getMessageStream();
  }

}


class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blue : Colors.white;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );

    TextStyle style = isMe
        ? TextStyle(
            color: Colors.white,
          )
        : TextStyle(
            color: Colors.black,
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Text(time,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 10.0,
            )),
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message, style: style),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}


