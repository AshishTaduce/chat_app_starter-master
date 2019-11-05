import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom_Selection extends StatefulWidget {
  @override
  _ChatRoom_SelectionState createState() => _ChatRoom_SelectionState();
}

class _ChatRoom_SelectionState extends State<ChatRoom_Selection> {
  @override
  FirebaseUser currentUser;
  final roomIdController = TextEditingController();
  CollectionReference rooms = Firestore.instance.collection('rooms');

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  //RoomsScreen build method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: roomIdController,
                  ),
                ),
                RaisedButton(
                  child: Text('Join Room'),
                ),
              ],
            ),
            RaisedButton(
              child: Text('Create New Room'),
              onPressed: () {
                Firestore.instance.collection('rooms').add({'roomID': 2});
              },
            ),
          ],
        ),
      ),
    );
  }
}
