/// Used for Google Places API.

class Location {
  final String address;
  final String geocode;

  Location({required this.address, required this.geocode});

  static Location fromJson(Map<String, dynamic> json) {
    return Location(address: json['description'], geocode: json['place_id']);
  }

  @override
  String toString() {
    return "$address : $geocode";
  }
}
