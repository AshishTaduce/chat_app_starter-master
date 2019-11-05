import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool loginFailed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'LogoImage',
                    child: Image(
                        image: NetworkImage(
                            'https://mclarencollege.in/images/icon.png'),
                        fit: BoxFit.contain),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36,
                        color: Color(0xFF4790F1),
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                  visible: loginFailed,
                  child: Text('Credentials invalid, plese check again.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'elon@musk.com',
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder()),
                    onChanged: (x) {
                      email = x;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'spacexRocks',
                        border: OutlineInputBorder()),
                    onChanged: (x) {
                      password = x;
                    },
                  ),


                  SizedBox(
                    height: 20,
                  ),

                  RaisedButton(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      try{
                        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                        Navigator.pushNamed(context, 'chatroom',);
                        loginFailed = false;
                      } catch (e){
                        print (e);

                        setState(() {
                          loginFailed = true;
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
