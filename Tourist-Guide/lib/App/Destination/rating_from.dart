import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/review.dart';
import 'package:tourist_guide/Classes/user.dart';

class ReviewForm extends StatefulWidget {
  final Destination destination;
  final User user;
  final VoidCallback onCloseBottomSeet;

  ReviewForm({this.destination, this.user, this.onCloseBottomSeet});
  @override
  ReviewFormState createState() {
    return new ReviewFormState();
  }
}

class ReviewFormState extends State<ReviewForm> {
  double rating = 0;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Give this distination a rating :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      SmoothStarRating(
        allowHalfRating: false,
        rating: rating,
        size: 32,
        color: Colors.orangeAccent,
        borderColor: Colors.grey,
        onRatingChanged: (r){
          setState(() {
            rating = r;
          });
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Leave a comment :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: TextField(
          maxLength: 84,
          decoration: InputDecoration(
            hintText: 'Leave a comment on this destination for \nother users to see.',
            labelText: 'Comment',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            ),
          ),
          onSubmitted: (c){
            comment = c;
          },
          onChanged: (c){
            comment = c;
          },
        ),
      ),
      Row(
        children: <Widget>[
          RawMaterialButton(
            child: Text('Cancel', style: TextStyle(color: const Color(0xff147efb), fontSize: 16),),
            onPressed: (){
              widget.onCloseBottomSeet();
            },
          ),
          Expanded(child: Container(),),
          RawMaterialButton(
            child: Text('Submit', style: TextStyle(color: const Color(0xff147efb), fontSize: 16),),
            onPressed: (){
              Review review =Review(
                user: widget.user,
                destination: widget.destination,
                rating: rating,
                comment: comment,
              );
              review.submitReview();
              widget.onCloseBottomSeet();
            },
          ),
        ],
      )
    ],
      );
  }
}