class Destination{
  String id;
  List<dynamic> images;
  List<dynamic> nearbyHotels;
  String name;
  String location;
  String description;
  double lat;
  double long;
  double rating;
  int reviewsNumber;

  Destination({
    this.id,
    this.images,
    this.nearbyHotels,
    this.name,
    this.location,
    this.description,
    this.lat,
    this.long,
    this.rating,
    this.reviewsNumber
  });
}