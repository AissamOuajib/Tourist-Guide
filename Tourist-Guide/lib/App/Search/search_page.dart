import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourist_guide/App/Search/destinations_search.dart';
import 'package:tourist_guide/App/Search/hotels_search.dart';
import 'package:tourist_guide/Classes/user.dart';

class Search extends StatefulWidget {
  final User user;

  Search({this.user});
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  String searchText = '';
  Widget appBarTitle = Text('Search', style: TextStyle(color: Colors.black),);
  Icon icon = Icon(Icons.search, color: Colors.black,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: new TextField(
          style: new TextStyle(
            color: Colors.black,
          ),
          decoration: new InputDecoration(
            
            enabledBorder: InputBorder.none,
            prefixIcon: new Icon(Icons.search, color: Colors.black),
            hintText: "Search....",
            hintStyle: new TextStyle(color: Colors.black)
          ),
          onChanged: (text)=> setState((){searchText = text.toLowerCase();}),
        ),
        bottom: new TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.red,
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(FontAwesomeIcons.mapMarkerAlt, size: 20,)),
            new Tab(icon: new Icon(FontAwesomeIcons.hotel, size: 20,)),
          ]
        )
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          DestinationSearch(user: widget.user, searchText: searchText,),
          HotelsSearch(user: widget.user, searchText: searchText),
        ],
      ),
    );
  }
}