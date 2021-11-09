import 'package:horticade/models/location.dart';

class Entity {
  final String uid;
  final String name;
  final Location location;
  final bool isAdmin;

  Entity({
    required this.uid, // FirebaseAuth user uid
    required this.isAdmin,
    required this.name,
    required this.location,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'is_admin': isAdmin,
        'address': location.address,
        'geocode': location.geocode,
      };
}
