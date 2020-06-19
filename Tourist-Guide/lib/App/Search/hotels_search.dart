import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Hotel/hotel_card.dart';
import 'package:tourist_guide/Classes/hotel.dart';
import 'package:tourist_guide/Classes/user.dart';

class HotelsSearch extends StatelessWidget {
  final User user;
  final String searchText;

  HotelsSearch({this.user, this.searchText});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
            stream: Firestore.instance.collection('hotels').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData) return Text('Loding...');
              final int count = snapshot.data.documents.length;
              return ListView.builder(
                itemCount: count, 
                itemBuilder: (BuildContext context, int index){
                  final DocumentSnapshot document = snapshot.data.documents[count - index -1];
                  if(searchText == ''){
                    if(document['pictures'] !=null && document['name'] !=null && document['location'] !=null && document['description'] !=null && document['lat'] !=null && document['long'] !=null && document['stars'] !=null && document['nearbyDestinations'] !=null && document['id'] !=null){
                     final Hotel hotel = Hotel(
                        id: document['id'],
                        pictures: document['pictures'],
                        name: document['name'],
                        location: document['location'],
                        descripton: document['description'],
                        lat: double.parse(document['lat'].toString()),
                        long: double.parse(document['long'].toString()),
                        stars: document['stars'],
                        nearbyDestinations: document['nearbyDestinations'],
                        websiteUrl: document['website'],
                      );
                      return Container(
                        height: 108,
                        child: HotelCard(
                          hotel: hotel,
                          user: user,
                        ),
                      );
                    }
                    else return Container();
                  }
                  else{
                    if((document['name'].toString().toLowerCase().contains(searchText) || document['location'].toString().toLowerCase().contains(searchText)) && document['pictures'] !=null && document['name'] !=null && document['location'] !=null && document['description'] !=null && document['lat'] !=null && document['long'] !=null && document['stars'] !=null && document['nearbyDestinations'] !=null && document['id'] !=null){
                     final Hotel hotel = Hotel(
                        id: document['id'],
                        pictures: document['pictures'],
                        name: document['name'],
                        location: document['location'],
                        descripton: document['description'],
                        lat: double.parse(document['lat'].toString()),
                        long: double.parse(document['long'].toString()),
                        stars: document['stars'],
                        nearbyDestinations: document['nearbyDestinations'],
                        websiteUrl: document['website'],
                      );
                      return Container(
                        height: 108,
                        child: HotelCard(
                          hotel: hotel,
                          user: user,
                        ),
                      );
                    }
                    else return Container();
                  }
                },
              );
            },
          );
  }
}