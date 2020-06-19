import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_dragger.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_indicator.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_reveal.dart';
import 'package:tourist_guide/App/Explore/Couverture/couvertures.dart';
import 'package:tourist_guide/Classes/auth.dart';

class Couvertures extends StatefulWidget {

  final AuthService auth;

  Couvertures({this.auth});

  @override
  _CouverturesState createState() => new _CouverturesState();
}

class _CouverturesState extends State<Couvertures> with TickerProviderStateMixin {

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  // _CouverturesState() {
    
  // }

  void initState() { 
    super.initState();
    slideUpdateStream = new StreamController<SlideUpdate>();
    // animatedPageDragger =AnimatedPageDragger(vsync: this, slideDirection: SlideDirection.none, slidePercent: 0.0, slideUpdateStream: slideUpdateStream);

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          
          animatedPageDragger.dispose();
        }
      });
    });
  }
  @override
  void dispose() { 
    slideUpdateStream.close();
    // animatedPageDragger.dispose();
    super.dispose();
  }
  CollectionReference col = Firestore.instance.collection('couvertures');

  final DocumentReference ref1 = Firestore.instance.collection('couvertures').document('firstCouverture');

  final DocumentReference ref2 = Firestore.instance.collection('couvertures').document('secondCouverture');
  int l;
  _fetch(){
    var assetPath;
    var title;
    var body;
    ref1.get().then((dataSnapshot){
      if(dataSnapshot.exists){
        if (!mounted) return;
        setState(() {
          assetPath = dataSnapshot.data['assetPath'];
          title = dataSnapshot.data['title'];
          body = dataSnapshot.data['body'];
          couvertures[0].title = title;
          couvertures[0].body = body;
          couvertures[0].backgroundAssetPath = assetPath;
        });
      }
    });
    ref2.get().then((dataSnapshot){
      if (!mounted) return;
      if(dataSnapshot.exists){
        setState(() {
          assetPath = dataSnapshot.data['assetPath'];
          title = dataSnapshot.data['title'];
          body = dataSnapshot.data['body'];
          couvertures[1].title = title;
          couvertures[1].body = body;
          couvertures[1].backgroundAssetPath = assetPath;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Stack(
        children: [
          new Couverture(
            viewModel: couvertures[activeIndex],
            percentVisible: 1.0,
            // auth: widget.auth,
          ),
          new CouvertureReveal(
            revealPercent: slidePercent,
            child: new Couverture(
              viewModel: couvertures[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: new CouvertureIndicator(
              viewModel: new CouvertureIndicatorViewModel(
                couvertures,
                activeIndex,
                slideDirection,
                slidePercent,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 180,
            child: new CouvertureDragger(
              canDragLeftToRight: activeIndex > 0,
              canDragRightToLeft: activeIndex < couvertures.length - 1,
              slideUpdateStream: this.slideUpdateStream,
            ),
          ),
        ],
      );
  }
}