import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/models/entity.dart';
import 'package:horticade/models/location.dart';

class EntityDao {
  static Future<Entity> entityFromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return await _entityFromDocumentData(data);
  }

  static Future<Entity> entityFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return await _entityFromDocumentData(data);
  }

  static Future<Entity> _entityFromDocumentData(
      Map<String, dynamic> data) async {
    return Entity(
      uid: data['uid'],
      isAdmin: data['is_admin'],
      name: data['name'],
      location: Location(
        address: data['address'],
        geocode: data['geocode'],
      ),
    );
  }
}
