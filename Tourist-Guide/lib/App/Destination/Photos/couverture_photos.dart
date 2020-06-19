import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_dragger.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_indicator.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture_reveal.dart';
import 'package:tourist_guide/App/Explore/Couverture/couvertures.dart';

class CouverturePhotos extends StatefulWidget {

  final List<dynamic> picutres;

  CouverturePhotos({this.picutres});

  @override
  _CouverturePhotosState createState() => new _CouverturePhotosState();
}

class _CouverturePhotosState extends State<CouverturePhotos> with TickerProviderStateMixin {

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _CouverturePhotosState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<CouvertureViewModel> cvtrs = [];
    for(int i = 0; i< widget.picutres.length; i++)
      cvtrs.add(CouvertureViewModel(backgroundAssetPath: widget.picutres[i]));
    return Stack(
        children: [
          new Couverture(
            viewModel: CouvertureViewModel(backgroundAssetPath: widget.picutres[activeIndex]),
            percentVisible: 1.0,
          ),
          new CouvertureReveal(
            revealPercent: slidePercent,
            child: new Couverture(
              viewModel: CouvertureViewModel(backgroundAssetPath: widget.picutres[nextPageIndex]),
              percentVisible: slidePercent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: new CouvertureIndicator(
              viewModel: new CouvertureIndicatorViewModel(
                cvtrs,
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
              canDragRightToLeft: activeIndex < widget.picutres.length - 1,
              slideUpdateStream: this.slideUpdateStream,
            ),
          ),
        ],
      );
  }
}