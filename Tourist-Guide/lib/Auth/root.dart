import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tourist_guide/App/home.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Auth/welcome_page.dart';
import 'package:tourist_guide/Classes/user.dart';

class RootPage extends StatefulWidget {
  final AuthService auth;
  RootPage({this.auth});
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  StreamController<User> currentUser;
  AuthState authState = AuthState.notSignedIn;
  User _user;

  _RootPageState(){
    currentUser = StreamController<User>();
    currentUser.stream.listen((User user){
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.curentUser().then((user) {        
      setState(() {
        _user = User(firebaseUser: user);
        authState = user == null ? AuthState.notSignedIn : AuthState.signedIn;
      });
    });
  }

  @override
  void dispose() {
    currentUser.close();
    super.dispose();
  }

  void _signedIn(){
    print('hhhhhhhh');
    setState(() {
      authState = AuthState.signedIn;
    });
    // setState(() {
      
    // });
  }

  void _signedOut(){
    widget.auth.signOut();
    setState(() {
      authState = AuthState.notSignedIn;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(authState == AuthState.notSignedIn){ 
      return WelcomePage(
        auth: widget.auth,
        onSignedIn: _signedIn,
        currentUser: this.currentUser,
      );
    }else{
      return Home(
        auth: widget.auth,
        onSignedOut: _signedOut,
        onSignedIn: _signedIn,
        user: _user,
        currentUser: this.currentUser,
      );
    }
  }
}

enum AuthState{
  signedIn,
  notSignedIn
}