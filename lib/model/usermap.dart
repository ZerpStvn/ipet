class UserMapping {
  String? lat;
  String? long;

  UserMapping({this.lat, this.long});

  factory UserMapping.getdocument(map) {
    return UserMapping(lat: map['lat'], long: map['long']);
  }
}
