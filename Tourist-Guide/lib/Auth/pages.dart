import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Classes/user.dart';

final pages = [
  new PageViewModel(
    backgroundAssetPath: 'assets/desertImage.jpg',
    heroAssetPath: 'assets/brochure.png',
    title: 'Explore',
    subtitle: 'Explore and discover different places and caltures all around the country',
    iconAssetPath: 'assets/desertIcon.png'
  ),
  new PageViewModel(
    backgroundAssetPath: 'assets/beachImage.jpg',
    heroAssetPath: 'assets/customerreview.png',
    title: 'Reviews',
    subtitle: 'Rate and see the rating of other users for every distination you want',
    iconAssetPath: 'assets/star.png'
  ),
  new PageViewModel(
    backgroundAssetPath: 'assets/mountainImage.jpg',
    heroAssetPath: 'assets/destination.png',
    title: 'Destinations',
    subtitle: 'Get the coordinations of the destinations you want to visit',
    iconAssetPath: 'assets/destinationIcon.png',
  ),
  new PageViewModel(
    backgroundAssetPath: 'assets/loginpageback.jpg',
    heroAssetPath: 'assets/users.png',
    title: 'Sign in',
    subtitle: 'Login to your accout to get acces to the application',
    iconAssetPath: 'assets/login.png',
    isLoginPage: true
  ),
];

class MyPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  final PageViewModel viewModel;
  final double percentVisible;
  final VoidCallback onSignedIn;
  final StreamController<User> currentUser;

  MyPage({
    this.viewModel,
    this.percentVisible = 1.0,
    this.onSignedIn,
    this.currentUser
  });



  @override
  Widget build(BuildContext context) {
    Future<void> _neverSatisfied() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please check you network and retry.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return new Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(viewModel.backgroundAssetPath),
            fit: BoxFit.cover
          )
        ),
        child: new Opacity(
          opacity: percentVisible,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Transform(
                  transform: new Matrix4.translationValues(0.0, 60.0 * (1.0 - percentVisible), 0.0),
                  child: new Padding(
                    padding: new EdgeInsets.only(bottom: 20.0),
                    child: new Image.asset(
                        viewModel.heroAssetPath,
                        width: 200.0,
                        height: 200.0
                    ),
                  ),
                ),
                new Transform(
                  transform: new Matrix4.translationValues(0.0, 40.0 * (1.0 - percentVisible), 0.0),
                  child: new Padding(
                    padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Text(
                      viewModel.title,
                      style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'FlamanteRoma',
                        fontSize: 34.0,
                      ),
                    ),
                  ),
                ),
                new Transform(
                  transform: new Matrix4.translationValues(0.0, 40.0 * (1.0 - percentVisible), 0.0),
                  child: new Padding(
                    padding: new EdgeInsets.only(bottom: 75.0, right: 15, left: 15),
                    child: new Text(
                      viewModel.subtitle,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: viewModel.isLoginPage
                  ?RawMaterialButton(
                    fillColor: Colors.deepOrange,
                    splashColor: Colors.orangeAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        // There is no Internet Connection
                        _neverSatisfied();
                      } else{ 
                        FirebaseUser firebaseUser = await _auth.googleSignIn();
                        User user = new User(firebaseUser: firebaseUser);
                        currentUser.add(user);
                        onSignedIn();
                      }
                    },
                  ): Container(),
                )
              ]
          ),
        )
    );
  }
}

class PageViewModel {
  final String backgroundAssetPath;
  final String heroAssetPath;
  final String title;
  final String subtitle;
  final String iconAssetPath;
  final bool isLoginPage;

  PageViewModel({
    this.backgroundAssetPath,
    this.heroAssetPath,
    this.title,
    this.subtitle,
    this.iconAssetPath,
    this.isLoginPage = false
  });
}