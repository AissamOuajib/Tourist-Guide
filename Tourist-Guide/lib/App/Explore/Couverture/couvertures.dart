import 'package:flutter/material.dart';

List<CouvertureViewModel> couvertures = [
  CouvertureViewModel(),
  CouvertureViewModel(),
];

class Couverture extends StatelessWidget {
  final CouvertureViewModel viewModel;
  final double percentVisible;

  Couverture({this.viewModel, this.percentVisible = 1.0});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/palceHolder.png'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: viewModel.backgroundAssetPath != '' ? NetworkImage(viewModel.backgroundAssetPath):AssetImage('assets/palceHolder.png'),
                      fit: BoxFit.cover,
                    ),
                    // boxShadow: [
                    //   BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 3)
                    // ]
                  ),
                  child: new Opacity(
                    opacity: percentVisible,
                    child: Transform(
                      transform: new Matrix4.translationValues(
                          0.0, 80.0 * (1.0 - percentVisible), 0.0),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Padding(
                              padding: new EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 10),
                              child: new Text(
                                viewModel.title,
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'FlamanteRoma',
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                            new Padding(
                              padding: new EdgeInsets.only(bottom: 60, left: 10),
                              child: new Text(
                                viewModel.body,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  )),
            ]),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1.2)
              ]),
            )
        ],
      ),
    );
  }
}

class CouvertureViewModel {
  String backgroundAssetPath;
  String title;
  String body;

  CouvertureViewModel({
    this.backgroundAssetPath= '',
    this.title= '',
    this.body = '',
  });
}
