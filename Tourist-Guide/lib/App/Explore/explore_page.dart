import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Explore/Circuits/destinations_network.dart';
import 'package:tourist_guide/App/Explore/Couverture/couverture.dart';
import 'package:tourist_guide/App/Explore/explore_card.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/destination_network.dart';
import 'package:tourist_guide/Classes/user.dart';

class Explore extends StatefulWidget {
  final AuthService auth;
  final User user;

  Explore({this.auth, this.user});

  @override
  ExploreState createState() {
    return new ExploreState();
  }
}

class ExploreState extends State<Explore> {
  var top;
  Widget w = Container();
  bool test = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
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
                              'Home',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'FlamanteRoma',
                                  fontWeight: FontWeight.bold),
                            )),
                        background: Couvertures(auth: widget.auth));
                  })),
            ];
          },
          body: _buildContent()),
    );
  }
  
  Widget _buildContent() {
    return ListView.builder(
        itemCount: 7,
        itemBuilder: (BuildContext content, int index) {
          return _buildHorizontalList(parentIndex: index);
        });
  }

  List<double> triTable(List<double> t) {
    double c;
    int i, j;
    for (i = 0; i < t.length - 1; i++)
      for (j = i + 1; j < t.length; j++)
        if (t[i] > t[j]) {
          c = t[i];
          t[i] = t[j];
          t[j] = c;
        }
    return t;
  }

  Widget _buildHorizontalList({int parentIndex}) {
    if (parentIndex == 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Explore',
              style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.black,
                  fontFamily: 'FlamanteRoma',
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'THE NEWEST DESTINATIONS WE ADDED',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black.withOpacity(0.8),
// fontFamily: 'FlamanteRoma',
// fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      );
    else if (parentIndex == 1)
      return SizedBox(
        height: 108 * 1.5,
        child: StreamBuilder(
          stream: Firestore.instance.collection('destinations').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Container();
            final int count = snapshot.data.documents.length;
            return ListView.builder(
// shrinkWrap: true,
// primary: false,
              scrollDirection: Axis.horizontal,
              itemCount: count <= 5 ? count : 5,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot document =
                    snapshot.data.documents[count - index - 1];
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
                  return ExploreCard(
                    destination: destination,
                    user: widget.user,
                  );
                } else
                  return Container();
              },
            );
          },
        ),
      );
    else if (parentIndex == 2)
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: Text(
          'Popular',
          style: TextStyle(
              fontSize: 26.0,
              color: Colors.black,
              fontFamily: 'FlamanteRoma',
              fontWeight: FontWeight.bold),
        ),
      );
    else if (parentIndex == 3)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Our most reviewed destinations',
                  style: TextStyle(fontSize: 14, fontFamily: 'FlamanteRoma'),
                ),
              ),
              SizedBox(
                child: StreamBuilder(
                  stream:
                      Firestore.instance.collection('destinations').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Container();
                    final int count = snapshot.data.documents.length;
                    List<int> indexesTable = [];
                    List<int> reviewsTable = [];
                    for (int h = 0; h < count; h++) {
                      final DocumentSnapshot d = snapshot.data.documents[h];
                      indexesTable.add(h);
                      reviewsTable.add(d['reviews']);
                    }

                    int c;

                    for(int i=0;i<count-1;i++)
                      for(int j=i+1;j<count;j++)
                          if ( reviewsTable[i] < reviewsTable[j] ) {
                              c = reviewsTable[i];
                              reviewsTable[i] = reviewsTable[j];
                              reviewsTable[j] = c;


                              c = indexesTable[i];
                              indexesTable[i] = indexesTable[j];
                              indexesTable[j] = c;
                          }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: count <= 5 ? count : 5,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot document = snapshot
                            .data.documents[indexesTable[index]];
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
                            height: 180,
                            child: ExploreCard(
                              destination: destination,
                              user: widget.user,
                            ),
                          );
                        } else
                          return Container();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    else if (parentIndex == 4)
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: Text(
          'Trending',
          style: TextStyle(
              fontSize: 26.0,
              color: Colors.black,
              fontFamily: 'FlamanteRoma',
              fontWeight: FontWeight.bold),
        ),
      );
    else if (parentIndex == 5)
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Our highly rated destinations',
                  style: TextStyle(fontSize: 14, fontFamily: 'FlamanteRoma'),
                ),
              ),
              SizedBox(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('destinations').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Container();
                    final int count = snapshot.data.documents.length;
                    List<int> indexesTable = [];
                    List<double> reviewsTable = [];
                    for (int h = 0; h < count; h++) {
                      final DocumentSnapshot d = snapshot.data.documents[h];
                      indexesTable.add(h);
                      reviewsTable.add(double.parse(d['rating'].toString()));
                    }

                    double c;
                    int t;

                    for(int i=0;i<count-1;i++)
                      for(int j=i+1;j<count;j++)
                          if ( reviewsTable[i] < reviewsTable[j] ) {
                              c = reviewsTable[i];
                              reviewsTable[i] = reviewsTable[j];
                              reviewsTable[j] = c;


                              t = indexesTable[i];
                              indexesTable[i] = indexesTable[j];
                              indexesTable[j] = t;
                          }

                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: count <= 5 ? count : 5,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot document = snapshot
                            .data.documents[indexesTable[index]];
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
                            height: 180,
                            child: ExploreCard(
                              destination: destination,
                              user: widget.user,
                            ),
                          );
                        } else
                          return Container();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
      else{
        DestinationsNetwork dn;
        return StreamBuilder(
          stream: Firestore.instance.collection('destinationNetwork').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData) return Container();
            final DocumentSnapshot d = snapshot.data.documents[0];
            List<dynamic> l = d['destinations'];
            List<Destination> list = [];
            return StreamBuilder(
              stream: Firestore.instance.collection('destinations').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData) return Container();
                list.clear();
                //?this first for loop keeps things in order
                //?you can delete it and use l.contains(dd.documentId) instead of l[j] == dd.documentID but things won't stay in order
                for(int j = 0; j < l.length; j++)
                  for(int i = 0; i < snapshot.data.documents.length; i++){
                    final DocumentSnapshot dd = snapshot.data.documents[i];
                    // print('l[0] ${l[0]}');
                    // print(dd.documentID);
                    //?this is the condition that keeps the order
                    if(l[j] == dd.documentID){
                      Destination des = Destination(
                        id: dd['id'],
                        name: dd['name'],
                        location: dd['location'],
                        description: dd['description'],
                        lat: double.parse(dd['lat'].toString()),
                        long: double.parse(dd['long'].toString()),
                        rating: double.parse(dd['rating'].toString()),
                        reviewsNumber: dd['reviews'],
                        images: dd['pictures'],
                        nearbyHotels: dd['nearbyHotels'],
                      );
                      // print('hhhhhhhhhh');
                      list.add(des);
                      dn = DestinationsNetwork(
                        destinations: list,
                        img: d['img'],
                        title: d['title'],
                        subtitle: d['subtitle']
                      );
                    }
                    // else return Container();
                  }
                if (list.length != 0)
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => new DestinationsNetworkPage(
                          destinations: dn,
                          user: widget.user,
                        ),
                      )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 45, top: 25, left: 10, right: 10),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          image: DecorationImage(
                            image: NetworkImage(dn.img),
                            fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: Container(),),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(dn.title, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'FlamanteRoma')),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0, top: 2, bottom: 20),
                              child: Text(dn.subtitle, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'FlamanteRoma')),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                else return Container();
              },
            );
            // return w;
            
          }
        );
      }
  }
}
