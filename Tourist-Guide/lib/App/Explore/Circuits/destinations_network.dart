import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/Circuits/map.dart';
import 'package:tourist_guide/App/Explore/explore_card.dart';
import 'package:tourist_guide/Classes/destination_network.dart';
import 'package:tourist_guide/Classes/user.dart';

class DestinationsNetworkPage extends StatelessWidget {
  final DestinationsNetwork destinations;
  final User user;

  DestinationsNetworkPage({this.destinations, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Maps(destinations: destinations.destinations, user: user),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 5),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: destinations.destinations.length,
                itemBuilder: (context, int index){
                  return ExploreCard(destination: destinations.destinations[index], user: user,);
                },
              ),
            )
          ),
        ],
      ),
    );
  }
}