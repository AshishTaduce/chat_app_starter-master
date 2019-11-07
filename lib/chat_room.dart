import 'dart:async';
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

  Future getRoomsList() async {
    roomsList = [];
    QuerySnapshot rooms =
        await Firestore.instance.collection('rooms').getDocuments();
    for (DocumentSnapshot roomID in rooms.documents) {
      roomsList.add(roomID.documentID);
    }
    print(roomsList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withAlpha(0),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new, color: Colors.black,),
              color: Colors.white,
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                controller.dispose();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: roomIdController,
              ),
            ),
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
            RaisedButton(
              child: Text('Create New Room'),
              onPressed: () async {
                int next() => 1001 + random.nextInt(10000 - 1001);
                int randomRoom = await next();
                roomGenerated = randomRoom;
                isVisible = true;
                Firestore.instance
                    .collection('rooms')
                    .document(
                      '$randomRoom',
                    )
                    .setData({
                  'timeStamp': DateTime.now(),
                });
                await getRoomsList();
                  Navigator.push(
                    (context),
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomID: randomRoom.toString(),
                      ),
                    ),
                  );
                },
            ),
            Expanded(
              flex: 7,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('rooms').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(25, 2, 25, 0),
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(),
                              onPressed: () async {
                                Firestore.instance
                                    .collection('rooms')
                                    .document(
                                    '${snapshot.data.documents[index].documentID}')
                                    .collection('messages');
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                        )));
                              },
                              child: Text(
                                snapshot.data.documents[index].documentID,
                                style: TextStyle(
                                    fontSize: 16),
                              ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
