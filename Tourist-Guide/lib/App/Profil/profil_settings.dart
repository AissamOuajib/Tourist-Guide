import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/Classes/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilSettings extends StatelessWidget {
  final User user;

  File image;

  Future getImage() async{
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  ProfilSettings({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profil', style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'FlamanteRoma'),),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').where('email', isEqualTo: user.firebaseUser.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Container();
          DocumentSnapshot document = snapshot.data.documents[0];
          return ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,  
                            color: Colors.grey,                  
                            image: DecorationImage(
                              image: NetworkImage(document['photoURL']),
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: CustomHalfCircleClipper(),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, 
                              color: Colors.white.withOpacity(0.8)                   
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: IconButton(
                                icon: Icon(Icons.camera_alt, color: Colors.black, size: 32,),
                                onPressed: (){
                                  getImage().then((_)async{
                                    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${document['displayName']} profile photo.jpg');
                                    final StorageUploadTask task = firebaseStorageRef.putFile(image);
                                    var dowurl = await (await task.onComplete).ref.getDownloadURL();
                                    user.setUserInfo(document.documentID, dowurl.toString(), document['displayName'], document['bio']);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: document['displayName'],
                        labelText: 'User Name :',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      onSubmitted: (c){
                        user.setUserInfo(document.documentID, user.firebaseUser.photoUrl, c == '' ? document['displayName'] : c, document['bio']);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: document['bio'],
                        labelText: 'Bio :',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      onSubmitted: (c){
                        user.setUserInfo(document.documentID, user.firebaseUser.photoUrl, document['displayName'], c == '' ? document['bio'] : c);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}