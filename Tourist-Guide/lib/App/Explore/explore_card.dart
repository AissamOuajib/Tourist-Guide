import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Destination/destination_page.dart';
import 'package:tourist_guide/Classes/destination.dart';
import 'package:tourist_guide/Classes/user.dart';

class ExploreCard extends StatelessWidget{

  final String previousDestination;
  final Destination destination;
  final User user;
  final String previousHotel;

  ExploreCard({this.destination,this.user, this.previousDestination = '', this.previousHotel});

  @override
  Widget build(BuildContext context) {
    double edgeSize = 8.0;
    double itemSize = 192*1.5 - edgeSize * 2.0;
    return InkWell(
      onTap: (){
        if(previousDestination == destination.id)
          Navigator.pop(context);
        else
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => new DestinationPage(
              destination: destination,
              user: user,
              previousHotel:previousHotel
            ),
          )
        );
      },
      child: Container(
        padding: EdgeInsets.all(edgeSize),
        // height: itemSize,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: Card(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                image: DecorationImage(
                  image: NetworkImage(destination.images[0]),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              alignment: AlignmentDirectional.center,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(destination.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(destination.location, style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.orangeAccent,),
                          Text((destination.rating.toString()=='NaN' || destination.rating == 0.0)? "No ratings yet" : destination.rating.toStringAsFixed(2), style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}