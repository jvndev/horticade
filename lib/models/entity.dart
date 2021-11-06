import 'package:horticade/models/location.dart';

class Entity {
  final String uid;
  final String name;
  final Location location;

  Entity({
    required this.uid, // FirebaseAuth user uid
    required this.name,
    required this.location,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': location.address,
        'geocode': location.geocode,
      };
}
