import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourist_guide/App/Destination/destination_page.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';

class Maps extends StatelessWidget {
  final List<Destination> destinations;
  final User user;

  Maps({this.destinations, this.user});
  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    for(int i = 0; i < destinations.length; i++){
      markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(destinations[i].lat, destinations[i].long),
        builder: (ctx) =>
        Column(
          children: <Widget>[
            Text((i+1).toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new DestinationPage(
                      destination: destinations[i],
                      user: user,
                    ),
                  )
                );
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.mapMarkerAlt,
                  color: Colors.red,
                ),
              )
            )
            
          ],
        ),
      ));
    }
    return Material(
      child: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(31.773187, -6.612123),
          zoom: 5.0,
          // minZoom: 10,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken': 'pk.eyJ1Ijoib3UtYWppYiIsImEiOiJjanM2OWpxbXgwbHpmNDNwa2VxNWxlYmw1In0.SNRbIl2kvxpmLySTPZqKRQ',
              'id': 'mapbox.streets',
            },
          ),
          new MarkerLayerOptions(
            markers: markers,
          ),
        ],
      ),
    );
  }
}