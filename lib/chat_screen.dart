import 'dart:math';
import 'bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomID;

  ChatScreen({this.chatRoomID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

TextEditingController controller = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {


  @override
  void initState() {
    getCurrentUser();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String message = '⚬⚬⚬⚬⚬⚬⚬';
  String user = '';
  List<Widget> widgetList = [];
  Random random = new Random();
  String userEmail = '';
  bool isMe;
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    userEmail = currentUser.email;
    return currentUser;
  }
  void getMessageStream() async {
    widgetList = [];
    await for (var snapshot
        in Firestore.instance.collection('rooms').document(widget.chatRoomID).collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        String text = message.data['text'];
        String sender = message.data['sender'];
        print('$text by $sender');
        widgetList.add(
          Bubble(
            message: '${message.data['text']}',
            sender: '${message.data['sender']}',
            delivered: true,
            isMe: isMe,
          ),
        );
        setState(() {});
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    //bool isMe = true;

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
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('rooms').document(widget.chatRoomID).collection('messages').snapshots(),
              builder: (context, snapshot) {
              if (!snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(

                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, int index) {
                  return Bubble(
                    message: snapshot.data.documents[index].data['text'],
                    sender: snapshot.data.documents[index].data['sender'],
                    delivered: true,
                    isMe: userEmail == snapshot.data.documents.first['sender'],
                  );
                },
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
              );
            }
              },
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
    await Firestore.instance.collection('rooms').document(widget.chatRoomID).collection('messages').add({
      'sender': userEmail,
      'text': controller.text,
    },);
    controller.clear();
    getMessageStream();
  }
}

