import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';

class Review{
  // String userId;
  User user;
  Destination destination;
  double rating;
  String comment;

  Review({
    // this.userId,
    this.user,
    this.destination,
    this.rating,
    this.comment
  });

  void submitReview(){
    print('submite clicked');
    CollectionReference col = Firestore.instance.collection('reviews');
    int counter;
    String documentName;
    int dm;
    col.getDocuments().then((QuerySnapshot snapshot){
      counter = snapshot.documents.length+1;
      bool test = false;
      for(int i = 0; i<counter-1; i++){
        if(snapshot.documents[i]['destination'] == this.destination.id && snapshot.documents[i]['user'] == this.user.firebaseUser.email){
          DocumentReference ref = col.document(snapshot.documents[i].documentID);
          ref.setData({
            'user': this.user.firebaseUser.email,
            'destination': this.destination.id,
            'rating': this.rating,
            'comment': this.comment,
          }, merge: true);
          test = true;
          setRatings();
          // print('review has been modified.');
        }
      }
      if(!test){
        if(counter != 1){
          documentName = snapshot.documents[counter-2].documentID;
          dm = int.parse(documentName) + 1;
        }
        DocumentReference ref = col.document(counter == 1 ? counter.toString().padLeft(6, '0') : dm.toString().padLeft(6, '0'));
        ref.get().then((dataSnapshot){
          if(!dataSnapshot.exists) 
          ref.setData({
            'user': this.user.firebaseUser.email,
            'destination': this.destination.id,
            'rating': this.rating,
            'comment': this.comment,
          }, merge: true);
          // print('review added');
        }).then((_){
          setRatings();
        });
      }
    });
  }

  void setRatings(){
    final _db = Firestore.instance;
    double ratingSome = 0;
    double r = 0.0;
    _db.collection('reviews').where('destination', isEqualTo: this.destination.id).getDocuments().then((snapshot){
      final count =snapshot.documents.length;
      for(int i= 0; i< count; i++){
        ratingSome += snapshot.documents[i].data['rating'];
      }
      r =ratingSome/count;
      DocumentReference ref = _db.collection('destinations').document(this.destination.id);
        ref.get().then((dataSnapshot){
          ref.setData({
            'id': this.destination.id,
            'name': this.destination.name,
            'location': this.destination.location,
            'description':this.destination.description,
            'lat':this.destination.lat,
            'long':this.destination.long,
            'pictures':this.destination.images,
            'rating': count == 0 ? 0.0 : r,
            'reviews': count,
          }, merge: true);
          // print('reviews updated');
        });
    });
  }
}