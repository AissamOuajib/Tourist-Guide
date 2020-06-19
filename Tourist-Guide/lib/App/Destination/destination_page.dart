import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Destination/Photos/couverture_photos.dart';
import 'package:tourist_guide/App/Destination/maps_widget.dart';
import 'package:tourist_guide/App/Destination/rating_from.dart';
import 'package:tourist_guide/App/Destination/reviews.dart';
import 'package:tourist_guide/App/Hotel/hotel_card.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tourist_guide/Classes/hotel.dart';
import 'package:tourist_guide/Classes/user.dart';


class DestinationPage extends StatefulWidget {
  final Destination destination;
  final User user;
  final String previousHotel;

  DestinationPage({this.destination, this.user, this.previousHotel});

  @override
  DestinationPageState createState() {
    return new DestinationPageState();
  }
}

class DestinationPageState extends State<DestinationPage> {
  @override
  Widget build(BuildContext context) {
    var top;
    return Scaffold(
      body: Stack(children: [
        NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    expandedHeight: 160.0,
                    floating: false,
                    pinned: true,
                    brightness: Brightness.light,
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top == 76 ? 1 : 0,
                            child: Text(
                              'Destination',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'FlamanteRoma',
                                  fontWeight: FontWeight.bold),
                            )),
                        background: CouverturePhotos(
                          picutres: widget.destination.images,
                        ),
                      );
                    })),
              ];
            },
            body: Builder(builder:(context) => _buildContent(context))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 160,
                child: Reviews(user: widget.user, destinationId: widget.destination.id),
              )
            ),
      ]),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext content, int index) {
        return _buildHorizontalList(parentIndex: index, context: context);
      }
    );
  }

  PersistentBottomSheetController t;

  closeBottomSheet(){
    t.close();
  }

  Widget _buildHorizontalList({int parentIndex, BuildContext context}) {
    if (parentIndex == 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20),
        child: Text(
          widget.destination.name,
          style: TextStyle(
              fontSize: 30.0,
              color: Colors.black,
              fontFamily: 'FlamanteRoma',
              fontWeight: FontWeight.bold),
        ),
      );
      else if (parentIndex == 1)
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.destination.location,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: 'FlamanteRoma',
                  ),
                ),
                Text(
                  widget.destination.rating == 0 ? 'No Ratings Yet' : widget.destination.rating.toStringAsFixed(2),
                  style: TextStyle(color: widget.destination.rating == 0 ? Colors.grey : Colors.orangeAccent, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SmoothStarRating(
                  allowHalfRating: true,
                  rating: (widget.destination.rating - widget.destination.rating.toInt() == 0.5) ? widget.destination.rating- 0.000001 : widget.destination.rating,
                  size: 20,
                  color: Colors.orangeAccent,
                  borderColor: Colors.grey,
                ),
              ],
            ),
            Expanded(child: Container(),),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10, bottom: 10),
              child: RawMaterialButton(
                fillColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                splashColor: Colors.blueAccent,
                onPressed: (){
                  t = showBottomSheet(
                    context: context,
                    builder: (BuildContext context){
                      // print('hhhdhhdhfkdkjfdk');
                      return Container(
                        width: double.infinity,
                        height: 253,
                        child: ReviewForm(destination: widget.destination, user: widget.user, onCloseBottomSeet: closeBottomSheet)
                        );
                    }
                  );
                  
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: Text(
                    'Review',
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    else if(parentIndex == 2){
      return ExpansionTile(
        title: Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5.0, bottom: 8),
            child: Text(widget.destination.description, textAlign: TextAlign.start,),
          ),
        ],
      );
    }
    else if(parentIndex == 3){
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'BEST NEARBY HOTELS',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('hotels').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData) return Container();
                final int counter = snapshot.data.documents.length;
                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: counter,
                  itemBuilder: (BuildContext context, int index){
                    DocumentSnapshot document = snapshot.data.documents[index];
                    List<dynamic> nearbylocation = document['nearbyDestinations'];
                    if(nearbylocation.contains(widget.destination.id)){
                      Hotel hotel = Hotel(
                        id: document['id'],
                        name: document['name'],
                        location: document['location'],
                        descripton: document['description'],
                        lat: double.parse(document['lat'].toString()),
                        long: double.parse(document['long'].toString()),
                        stars: document['stars'],
                        pictures: document['pictures'],
                        nearbyDestinations: nearbylocation,
                        websiteUrl: document['website'],
                      ); 
                      return Container(
                        height: 108*1.5,
                        child: HotelCard(hotel: hotel, user: widget.user, destinationId: widget.destination.id, previousHotelId: widget.previousHotel)
                      );
                    }
                    else return Container();
                  },
                );
              },
            ),
          ],
        ),
      );
    }
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'YOUR MAP',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
          Container(
            width: double.infinity, 
            height: 500, 
            child: MapsWidget(lat: widget.destination.lat, long: widget.destination.long)
          ),
        ],
      );
  }
}
