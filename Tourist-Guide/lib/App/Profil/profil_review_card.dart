import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Destination/destination_page.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';

class ProfilReviewCard extends StatelessWidget {
  final Destination destination;
  final double rating;
  final User user;
  final DocumentSnapshot reviewDocument;

  void setRatings(Destination destination){

    final _db = Firestore.instance;
    double rating = 0;
    double ratingSome = 0;
    _db.collection('reviews').where('destination', isEqualTo: destination.id).getDocuments().then((snapshot){
      final count =snapshot.documents.length;
      for(int i= 0; i< count; i++){
        ratingSome += snapshot.documents[i].data['rating'];
      }
      rating =ratingSome/count;
      DocumentReference ref = _db.collection('destinations').document(destination.id);
        ref.get().then((dataSnapshot){
          // if(!dataSnapshot.exists) 
          ref.setData({
            'id': destination.id,
            'name': destination.name,
            'location': destination.location,
            'description':destination.description,
            'lat':destination.lat,
            'long':destination.long,
            'pictures':destination.images,
            'rating': count == 0 ? 0.0 : rating,
            'reviews': count,
          }, merge: true);
          print('reviews updated');
        });
    });
  }

  ProfilReviewCard({this.destination, this.rating,this.user, this.reviewDocument});

  // final _db =Firestore.instance;
  // double s = 0;

  // getData(String destinationId){
  //   double ratingSome = 0;
  //   _db.collection('reviews').where('destination', isEqualTo: destinationId).getDocuments().then((snapshot){
  //     final count =snapshot.documents.length;
  //     for(int i= 0; i< count; i++){
  //       ratingSome += snapshot.documents[i].data['rating'];
  //     }
  //     s =ratingSome/count;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double edgeSize = 4.0;
    double itemSize = 192*1.5;
    return InkWell(
      onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => new DestinationPage(
                destination: destination,
                user: user,
              ),
            )
          );
      },
      child: Container(
        padding: EdgeInsets.all(edgeSize),
        child: SizedBox(
          width: itemSize,
          // height: itemSize,
          child: Card(
            elevation: 7,
            child: Column(
              children: <Widget>[
                Container(
                  height: 108*1.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    image: DecorationImage(
                      image: NetworkImage(destination.images[0]),
                      fit: BoxFit.cover
                    ),
                    // borderRadius: BorderRadius.circular(5)
                  ),
                  alignment: AlignmentDirectional.center,
                ),
                Container(
                  height: 80,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(destination.name, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(destination.location, style: TextStyle(color: Colors.black, fontSize: 16)),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.star, color: Colors.orangeAccent,),
                                    Text(rating.toStringAsFixed(1) ?? '0.0', style: TextStyle(color: Colors.black, fontSize: 16)),
                                  ],
                                ),
                                // Text(comment, style: TextStyle(color: Colors.black, fontSize: 16)),
                              ],
                            ),
                            Expanded(child: Container(),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                onPressed: (){
                                  DocumentReference ref = Firestore.instance.collection('reviews').document(reviewDocument.documentID);
                                  // ref.delete().then((_){ setRatings(destination);});
                                  ref.delete();
                                  setRatings(destination);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}