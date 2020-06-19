import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Profil/profil_review_card.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';


class RatedDistinationCard extends StatelessWidget {
  final User user;
  RatedDistinationCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'THE DESTINATIONS YOU REVIEWED',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
          child: StreamBuilder(
            stream: Firestore.instance.collection('reviews').where('user', isEqualTo: user.firebaseUser.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData) return Container();
              final int count = snapshot.data.documents.length;
              return Padding(
                padding: count == 0 ?  const EdgeInsets.only(top: 40.0) : const EdgeInsets.only(top: 2.0),
                child: count == 0 
                ?  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "You didn't review any destination yet!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
                : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: count, 
                  itemBuilder: (BuildContext context, int index){
                    final DocumentSnapshot reviewDocument = snapshot.data.documents[count - index -1];
                    String destinationId = reviewDocument['destination'];
                    int id = int.parse(destinationId)-1;
                    return Column(
                      children: <Widget>[
                        StreamBuilder(
                            stream: Firestore.instance.collection('destinations').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if(!snapshot.hasData) return Container();
                              Destination destination = Destination(
                                id: snapshot.data.documents[id]['id'],
                                name: snapshot.data.documents[id]['name'],
                                description: snapshot.data.documents[id]['description'],
                                location: snapshot.data.documents[id]['location'],
                                long: double.parse(snapshot.data.documents[id]['long'].toString()),
                                lat: double.parse(snapshot.data.documents[id]['lat'].toString()),
                                images: snapshot.data.documents[id]['pictures'],
                                nearbyHotels: snapshot.data.documents[id]['nearbyHotels'],
                                rating: double.parse(snapshot.data.documents[id]['rating'].toString()),
                              );
                              return ProfilReviewCard(destination: destination, user: user, rating: reviewDocument['rating'], reviewDocument: reviewDocument);
                            },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          ),
        ],
      ),
    );
  }
}