class Hotel{
  String id;
  String name;
  String location;
  String descripton;
  String websiteUrl;
  double lat;
  double long;
  int stars;
  List<dynamic> pictures;
  List<dynamic> nearbyDestinations;

  Hotel({
    this.id,
    this.name,
    this.location,
    this.descripton,
    this.websiteUrl,
    this.lat,
    this.long,
    this.stars,
    this.pictures,
    this.nearbyDestinations
  });
}