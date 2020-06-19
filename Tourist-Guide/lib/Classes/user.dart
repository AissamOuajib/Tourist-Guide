import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class User {
  FirebaseUser firebaseUser;

  User({this.firebaseUser});

  void setUserInfo(String docId, String photoUrl, String userName, String bio){
    final DocumentReference ref = Firestore.instance.collection('users').document(docId);
    ref.setData({
      'displayName': userName,
      'photoURL': photoUrl,
      'bio': bio,
      'email': this.firebaseUser.email,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }
}