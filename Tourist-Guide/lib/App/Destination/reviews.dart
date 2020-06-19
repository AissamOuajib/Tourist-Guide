import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Destination/reveiw_card.dart';
import 'package:tourist_guide/Classes/user.dart';

class Reviews extends StatefulWidget {
  final User user;
  final String destinationId;
  Reviews({this.user, this.destinationId});

  @override
  ReviewsState createState() {
    return new ReviewsState();
  }
}

class ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: Firestore.instance.collection('reviews').where('destination', isEqualTo: widget.destinationId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData) return Text('Loading...');
            final int count = snapshot.data.documents.length;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              primary: false,
              itemCount: count, 
              itemBuilder: (BuildContext context, int index){
                final DocumentSnapshot reviewDocument = snapshot.data.documents[count - index -1];
                return ReviewCard(email: reviewDocument['user'], rating: double.parse(reviewDocument['rating'].toString()), comment: reviewDocument['comment']);
              },
            );
          },
        );
  }
}