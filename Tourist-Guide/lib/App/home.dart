import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/explore_page.dart';
import 'package:tourist_guide/App/Profil/profil_page.dart';
import 'package:tourist_guide/App/Search/search_page.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Classes/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  final AuthService auth;
  final VoidCallback onSignedOut;
  final VoidCallback onSignedIn;
  final User user;
  final StreamController<User> currentUser;

  Home({this.auth, this.user, this.onSignedOut, this.onSignedIn, this.currentUser});

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Widget activeScreen;
  Color selectedColor = Colors.red;
  Color btnColor = Colors.grey;

  int _currentIndex = 0;

  void initState() { 
    super.initState();
    activeScreen = Explore(auth: widget.auth, user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Explore(auth: widget.auth, user: widget.user),
      Search(user: widget.user),
      Profil(auth: widget.auth,user: widget.user,onSignedOut: widget.onSignedOut, onSignedIn: widget.onSignedIn, currentUser: widget.currentUser)
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _currentIndex =index;
            activeScreen = _children[index];
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
           icon: new Icon(FontAwesomeIcons.home),
           title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text('Profile')
          )
        ],
      ),
    );
  }
}
