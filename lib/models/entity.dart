import 'package:horticade/models/dao.dart';
import 'package:horticade/models/location.dart';

class Entity extends Dao {
  final String name;
  final Location location;

  Entity({
    required uid, // FirebaseAuth user uid
    required this.name,
    required this.location,
  }) : super(uid: uid);

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'address': location.address,
        'geocode': location.geocode,
      };
}
