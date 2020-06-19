import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/explore_card.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';

class DestinationSearch extends StatelessWidget {
  final User user;
  final String searchText;

  DestinationSearch({this.user, this.searchText});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
            stream: Firestore.instance.collection('destinations').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData) return Text('Loding...');
              final int count = snapshot.data.documents.length;
              return ListView.builder(
                itemCount: count, 
                itemBuilder: (BuildContext context, int index){
                  final DocumentSnapshot document = snapshot.data.documents[count - index -1];
                  if(searchText == ''){
                    if(document['pictures'] !=null && document['name'] !=null && document['location'] !=null && document['description'] !=null && document['lat'] !=null && document['long'] !=null){
                     final Destination destination = Destination(
                        id: document['id'],
                        images: document['pictures'],
                        name: document['name'],
                        location: document['location'],
                        description: document['description'],
                        lat: double.parse(document['lat'].toString()),
                        long: double.parse(document['long'].toString()),
                        rating: double.parse(document['rating'].toString()),
                        reviewsNumber: document['reviews']
                      );
                      return Container(
                        height: 108,
                        child: ExploreCard(
                          destination: destination,
                          user: user,
                        ),
                      );
                    }
                    else return Container(color: Colors.red,);
                  }
                  else{
                    if(document['pictures'] !=null && document['name'] !=null && (document['name'].toString().toLowerCase().contains(searchText) || document['location'].toString().toLowerCase().contains(searchText)) && searchText != '' && document['location'] !=null && document['description'] !=null && document['lat'] !=null && document['long'] !=null){
                      final Destination destination = Destination(
                        id: document['id'],
                        images: document['pictures'],
                        name: document['name'],
                        location: document['location'],
                        description: document['description'],
                        lat: double.parse(document['lat'].toString()),
                        long: double.parse(document['long'].toString()),
                        rating: double.parse(document['rating'].toString()),
                        reviewsNumber: document['reviews']
                      );
                      return Container(
                        height: 108,
                        child: ExploreCard(
                          destination: destination,
                          user: user,
                        ),
                      );
                    }
                    else return Container(color: Colors.red,);
                  }
                },
              );
            },
          );
  }
}