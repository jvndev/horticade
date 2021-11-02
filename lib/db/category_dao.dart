import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/models/category.dart';

class CategoryDao {
  static Future<Category> categoryFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return await _categoryFromDocumentData(data);
  }

  static Future<Category> categoryFromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return await _categoryFromDocumentData(data);
  }

  static Future<Category> _categoryFromDocumentData(
      Map<String, dynamic> data) async {
    Category category = Category(name: data['name']);

    category.uid = data['uid'];

    return category;
  }
}
