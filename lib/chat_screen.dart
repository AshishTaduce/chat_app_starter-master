import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text('Chat', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: TextField(),
          ),
          FlatButton(
            child: Text(
              'Send',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
