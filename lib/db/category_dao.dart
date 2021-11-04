import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/shared/types.dart';

class CategoryDao {
  static Future<List<Category>> categoryFromQuerySnapshot({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    List<CategoryPredicate>? filters,
  }) async {
    List<Category> orders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      orders.add(await categoryFromQueryDocumentSnapshot(qds));
    }

    if (filters != null) {
      for (CategoryPredicate filter in filters) {
        orders = orders.where(filter).toList();
      }
    }

    return orders;
  }

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
