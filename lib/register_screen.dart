import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email;
  String password;
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
                    'Register',
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
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'elon@musk.com',
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder()),
                      onChanged: (newvalue){
                        email = newvalue;
                      }
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
                    onChanged: (newValue){
                      password = newValue;
                    }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    ),
                    color: Colors.purple,
                    onPressed: () {
                      try{
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                        Navigator.pushNamed(context, 'login');
                      }
                      catch(e){
                        print (e);
                        SnackBar snackBar = SnackBar(content: Text('$e'));
                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {});
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
