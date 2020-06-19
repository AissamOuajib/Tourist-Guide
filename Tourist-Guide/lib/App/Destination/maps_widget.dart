import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapsWidget extends StatelessWidget {
  final double lat;
  final double long;

  MapsWidget({this.lat = 51.5, this.long = -0.09});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(lat, long),
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken': 'pk.eyJ1Ijoib3UtYWppYiIsImEiOiJja2JodGd5eW4wN2hyMndteTU4OHU2c2UwIn0.vN_8Vni5cBQ75EWksC_Sig',
              'id': 'mapbox.streets',
            },
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: new LatLng(lat, long),
                builder: (ctx) =>
                Container(
                  child: Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: Colors.red,
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

}