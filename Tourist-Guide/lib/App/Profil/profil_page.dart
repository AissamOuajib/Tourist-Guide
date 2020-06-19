import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Profil/profil_settings.dart';
import 'package:tourist_guide/App/Profil/rated_distination_cards.dart';
import 'package:tourist_guide/Auth/root.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Classes/user.dart';

class Profil extends StatefulWidget {
  final AuthService auth;
  final User user;
  final VoidCallback onSignedOut;
  final VoidCallback onSignedIn;
  final VoidCallback onSwitchAccount;
  final StreamController<User> currentUser;

  Profil({this.auth, this.user, this.onSignedOut, this.onSignedIn, this.currentUser, this.onSwitchAccount});
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  Map userSnapshot = Map();

  void choiceAction(String choice) async{
    if(choice == Constants.SwitchAccount){
        widget.auth.signOut();
        FirebaseUser firebaseUser = await widget.auth.googleSignIn();
        User user = new User(firebaseUser: firebaseUser);
        widget.currentUser.add(user);
        widget.onSignedIn();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RootPage(auth: AuthService())
          ),
          (Route<dynamic> route) => false
        );
    }else if(choice == Constants.SignOut){
      widget.onSignedOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('rebuilded');
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.5),
        title: Text('Profil', style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'FlamanteRoma'),),
        leading: IconButton(
          icon: Icon(Icons.edit, color: Colors.black,),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilSettings(user: widget.user),
              )
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon:Icon(Icons.more_vert, color: Colors.black),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData) return Container();
            final int count = snapshot.data.documents.length;
            return ListView.builder(
              itemCount: count, 
              itemBuilder: (BuildContext context, int index){
                final DocumentSnapshot document = snapshot.data.documents[index];
                if(document['email'] == widget.user.firebaseUser.email)
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,                    
                          image: DecorationImage(
                            image: NetworkImage(document['photoURL']),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      Text(document['displayName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text(document['bio']),
                      RatedDistinationCard(user: widget.user),
                      Padding(padding: EdgeInsets.all(20),)
                    ],
                  ),
                );
                else return Container();
              },
            );
          },
        ),
      ),
    );
  }
}


class Constants{
  static const String SwitchAccount = 'Switch Account';
  // static const String Settings = 'Settings';
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    SwitchAccount,
    // Settings,
    SignOut
  ];
}