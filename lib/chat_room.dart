import 'dart:io';

import 'package:chat_app_starter/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChatRoom_Selection extends StatefulWidget {
  @override
  _ChatRoom_SelectionState createState() => _ChatRoom_SelectionState();
}

class _ChatRoom_SelectionState extends State<ChatRoom_Selection> {

  @override
  FirebaseUser currentUser;
  List roomsList = [];
  final roomIdController = TextEditingController();
  CollectionReference rooms = Firestore.instance.collection('rooms');

  String roomId;
  //To generate random chat rooms
  void joinRoom() async {
    await for (var snapshot
        in Firestore.instance.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        setState(() {});
      }
    }
  }

  Random random = Random();
  int roomGenerated;
  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  bool isVisible = false;
  @override
  Future getRoomsList() async {
    roomsList = [];
    QuerySnapshot rooms =
        await Firestore.instance.collection('rooms').getDocuments();
//TODO: list of rooms method 2
    for (DocumentSnapshot roomID in rooms.documents) {
      roomsList.add(roomID.documentID);
    }
    print(roomsList);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: roomIdController,
                  ),
                ),
                Text('Join Room'),
                RaisedButton(
                  disabledColor: Colors.grey,
                  child: Text('Join Room'),
                  onPressed: () async {
                    print('here now 1');
                    String tempRoomId = roomIdController.text;
                    roomIdController.clear();
                    roomId = tempRoomId;
                    print('trying to join room $roomId');

                    await getRoomsList();
                    if (roomsList.contains(roomId)) {
                      Navigator.push(
                        (context),
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatRoomID: roomId,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text('Create New Room'),
              onPressed: () async {
                int next() => 1001 + random.nextInt(10000 - 1001);
                int randomRoom = await next();
                Firestore.instance
                    .collection('rooms')
                    .document(
                      '$randomRoom}',
                    )
                    .setData({
                  'timeStamp': DateTime.now(),
                });
                isVisible = true;
                roomGenerated = randomRoom;
                sleep(Duration(seconds: 3));
                isVisible = false;
                },
            ),
            Visibility(
                visible: isVisible,
                child: Text('The room no generateed is $roomGenerated', textAlign: TextAlign.center, style: TextStyle(color: Colors.indigoAccent),)),
          ],
        ),
      ),
    );
  }
}
