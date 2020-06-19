import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Destination/Photos/couverture_photos.dart';
import 'package:tourist_guide/App/Destination/maps_widget.dart';
import 'package:tourist_guide/App/Explore/explore_card.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tourist_guide/Classes/hotel.dart';
import 'package:tourist_guide/Classes/user.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelPage extends StatefulWidget {
  final Hotel hotel;
  final User user;
  final String destinationId;

  HotelPage({this.hotel, this.user, this.destinationId});

  @override
  HotelPageState createState() {
    return new HotelPageState();
  }
}

class HotelPageState extends State<HotelPage> {
  @override
  Widget build(BuildContext context) {
    var top;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                            'Hotel',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: 'FlamanteRoma',
                                fontWeight: FontWeight.bold),
                          )),
                      background: CouverturePhotos(
                        picutres: widget.hotel.pictures,
                      ),
                    );
                  })),
            ];
          },
          body: Builder(builder: (context) => _buildContent(context))),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext content, int index) {
          return _buildHorizontalList(parentIndex: index, context: context);
        });
  }

  PersistentBottomSheetController t;

  closeBottomSheet() {
    t.close();
  }

  Widget _buildHorizontalList({int parentIndex, BuildContext context}) {
    if (parentIndex == 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20),
        child: Text(
          widget.hotel.name,
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
                  widget.hotel.location,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: 'FlamanteRoma',
                    // fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  widget.hotel.stars.toString(),
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SmoothStarRating(
                  allowHalfRating: true,
                  rating: double.parse(widget.hotel.stars.toString()),
                  size: 20,
                  color: Colors.orangeAccent,
                  borderColor: Colors.grey,
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10, bottom: 10),
              child: RawMaterialButton(
                fillColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  launch(widget.hotel.websiteUrl);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(
                      'Book now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),
          ],
        ),
      );
    else if (parentIndex == 2) {
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
            child: Text(
              widget.hotel.descripton,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    } else if (parentIndex == 3) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'BEST NEARBY DESTINATIONS',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black.withOpacity(0.8),
                  // fontFamily: 'FlamanteRoma',
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('destinations').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Container();
                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    List<dynamic> nearbyHotels = document['nearbyHotels'];
                    if (nearbyHotels.contains(widget.hotel.id)) {
                      if (document['pictures'] != null &&
                          document['name'] != null &&
                          document['location'] != null &&
                          document['description'] != null &&
                          document['lat'] != null &&
                          document['long'] != null) {
                        final Destination destination = Destination(
                          id: document['id'],
                          images: document['pictures'],
                          nearbyHotels: document['nearbyHotels'],
                          name: document['name'],
                          location: document['location'],
                          description: document['description'],
                          lat: double.parse(document['lat'].toString()),
                          long: double.parse(document['long'].toString()),
                          rating: double.parse(document['rating'].toString()),
                        );
                        return Container(
                          height: 108 * 1.5,
                          child: ExploreCard(
                              destination: destination,
                              user: widget.user,
                              previousDestination: widget.destinationId,
                              previousHotel: widget.hotel.id),
                        );
                      } else
                        return Container();
                    } else
                      return Container();
                  },
                );
              },
            ),
          ],
        ),
      );
    } else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5.0, bottom: 5),
            child: Text(
              'YOUR MAP',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black.withOpacity(0.8),
                // fontFamily: 'FlamanteRoma',
                // fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            width: double.infinity, height: 500, 
            child: MapsWidget(lat: widget.hotel.lat, long: widget.hotel.long)
          ),
        ],
      );
  }
}
