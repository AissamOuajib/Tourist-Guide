import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewCard extends StatefulWidget {
  final String email;
  final double rating;
  final String comment;

  ReviewCard({this.email, this.rating, this.comment});

  @override
  ReviewCardState createState() {
    return new ReviewCardState();
  }
}

class ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: double.infinity,
              width: 280,
              color: Colors.white.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data.documents[0]['photoURL']),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 8)),
                        Column(
                          children: <Widget>[
                            Text(
                              snapshot.data.documents[0]['displayName'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SmoothStarRating(
                              rating: widget.rating,
                              size: 24,
                              color: Colors.orangeAccent,
                              borderColor: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      widget.comment,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
