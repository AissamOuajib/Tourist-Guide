import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseAuth {
  Future<FirebaseUser> curentUser();
  Future<FirebaseUser> googleSignIn();
  void setUserData(FirebaseUser user, DocumentReference ref, int counter);
  void signOut();
}

class AuthService implements BaseAuth{
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Shared State for Widgets
  // Observable<FirebaseUser> user; // firebase user
  // Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  // PublishSubject loading = PublishSubject();

  // constructor
  // AuthService() {
  //   user = Observable(_auth.onAuthStateChanged);

  //   profile = user.switchMap((FirebaseUser u) {
  //     if (u != null) {
  //       return _db
  //           .collection('users')
  //           .document(u.uid)
  //           .snapshots()
  //           .map((snap) => snap.data);
  //     } else {
  //       return Observable.just({});
  //     }
  //   });
  // }

  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if(googleUser!=null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if(googleAuth != null) {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        if(credential != null){
          final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
          print("signed in " + user.displayName);
          //Here we create the Firestore document of the user if it's the first time he logs in.
          CollectionReference col = _db.collection('users');
          int counter;
          col.getDocuments().then((QuerySnapshot snapshot){
            counter = snapshot.documents.length+1;
            bool test = false;
            for(int i = 0; i<counter-1; i++){
              if(snapshot.documents[i]['email'] == user.email){
                DocumentReference ref = col.document(snapshot.documents[i].documentID);
                ref.setData({
                  'email': user.email,
                  'photoURL': snapshot.documents[i]['photoURL'],
                  'displayName': snapshot.documents[i]['displayName'],
                  'lastSeen': DateTime.now(),
                  'bio': snapshot.documents[i]['bio'],
                  // 'id': '${snapshot.documents[i].documentID}',
                }, merge: true);
                test = true;
              }
            }
            if(!test){
              DocumentReference ref = col.document('$counter');
              ref.get().then((dataSnapshot){
                if(!dataSnapshot.exists) setUserData(user, ref, counter);
              });
            }
          });
          return user;
        }
      }
    }
    return null;
  }
    

  // Future<FirebaseUser> googleSignIn() async {
  //   // Start
  //   // loading.add(true);

  //   // Step 1
  //   GoogleSignInAccount googleUser = await _googleSignIn.signIn();

  //   // Step 2
  //   GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //   FirebaseUser user = await _auth.signInWithGoogle(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

  //   CollectionReference col = _db.collection('users');
  //   int counter;
  //   col.getDocuments().then((QuerySnapshot snapshot){
  //     counter = snapshot.documents.length+1;
  //     bool test = false;
  //     for(int i = 0; i<counter-1; i++){
  //       if(snapshot.documents[i]['email'] == user.email){
  //         DocumentReference ref = col.document(snapshot.documents[i].documentID);
  //         ref.setData({
  //           'email': user.email,
  //           'photoURL': snapshot.documents[i]['photoURL'],
  //           'displayName': snapshot.documents[i]['displayName'],
  //           'lastSeen': DateTime.now(),
  //           'bio': snapshot.documents[i]['bio'],
  //           // 'id': '${snapshot.documents[i].documentID}',
  //         }, merge: true);
  //         test = true;
  //       }
  //     }
  //     if(!test){
  //       DocumentReference ref = col.document('$counter');
  //       ref.get().then((dataSnapshot){
  //         if(!dataSnapshot.exists) setUserData(user, ref, counter);
  //       });
  //     }
  //   });

  //   // Done
  //   // loading.add(false);
  //   // print("signed in " + user.displayName);
  //   return user;
  // }

  void setUserData(FirebaseUser user, DocumentReference ref, int counter) async {
    ref.setData({
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'bio': "Hey There, I'm using this app.",
      // 'id': '$counter',
    }, merge: true);
  }

  void signOut() {
    _googleSignIn.signOut();
    _auth.signOut();
  }

  Future<FirebaseUser> curentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }
}
