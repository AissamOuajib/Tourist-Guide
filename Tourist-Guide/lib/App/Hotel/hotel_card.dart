import 'package:flutter/material.dart';
import 'package:tourist_guide/App/Hotel/hotel_page.dart';
import 'package:tourist_guide/Classes/hotel.dart';
import 'package:tourist_guide/Classes/user.dart';

class HotelCard extends StatelessWidget{
  final Hotel hotel;
  final User user;
  final String destinationId;
  final String previousHotelId;

  HotelCard({this.hotel, this.user, this.destinationId, this.previousHotelId});

  @override
  Widget build(BuildContext context) {
    double edgeSize = 8.0;
    double itemSize = 192*1.5 - edgeSize * 2.0;
    return InkWell(
      onTap: (){
        if(previousHotelId ==hotel.id)
        Navigator.pop(context);
        else
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => new HotelPage(
              hotel: hotel,
              user: user,
              destinationId: destinationId,
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
                  image: NetworkImage(hotel.pictures[0]),
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
                      Text(hotel.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(hotel.location, style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.orangeAccent,),
                          Text(hotel.stars.toString() , style: TextStyle(color: Colors.white, fontSize: 16)),
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