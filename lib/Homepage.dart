import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authentification/Start.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(220, 255, 255, 255),
        body: Container(
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      height: 300,
                      // child: Image(
                      //   image: AssetImage("images/welcome.png"),
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    Container(
                      child: Text(
                        "Hello ${user.displayName} you are Logged in as ${user.email}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: signOut,
                      child: Text('Signout',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
        ));
  }
}
