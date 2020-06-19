import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/Couverture/couvertures.dart';

class CouvertureIndicator extends StatelessWidget {

  final CouvertureIndicatorViewModel viewModel;

  CouvertureIndicator({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    List<CouvertureBubble> bubbles = [];
    for (var i = 0; i < viewModel.pages.length; ++i) {
      // final page = viewModel.pages[i];

      var percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex
          || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        new CouvertureBubble(
          viewModel: new CouvertureBubbleViewModel(
            Colors.white,
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    final bubbleWidth = 55.0;
    final baseTranslation = ((viewModel.pages.length * bubbleWidth) / 2) - (bubbleWidth / 2);
    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * viewModel.slidePercent;
    }

    return new Column(
      children: [
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
        new Expanded(child: new Container()),
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class CouvertureIndicatorViewModel {
  final List<CouvertureViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  CouvertureIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}

class CouvertureBubble extends StatelessWidget {

  final CouvertureBubbleViewModel viewModel;

  CouvertureBubble({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 40.0,
      height: 40.0,
      child: new Center(
        child: new Container (
          width: lerpDouble(15.0, 40.0, viewModel.activePercent),
          height: lerpDouble(5.0, 15.0, viewModel.activePercent),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: viewModel.color,
          ),
        ),
      ),
    );
  }
}


class CouvertureBubbleViewModel {
  final Color color;
  final bool isHollow;
  final double activePercent;

  CouvertureBubbleViewModel(
    this.color,
    this.isHollow,
    this.activePercent,
  );
}