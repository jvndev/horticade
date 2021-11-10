import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/types.dart';

class SubCategoryDao {
  static final DatabaseService databaseService = DatabaseService();

  static Future<List<SubCategory>> subCategoryFromQuerySnapshot({
    required Category category,
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    List<SubCategoryPredicate>? filters,
  }) async {
    List<SubCategory> orders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      orders.add(await subCategoryFromQueryDocumentSnapshot(category, qds));
    }

    if (filters != null) {
      for (SubCategoryPredicate filter in filters) {
        orders = orders.where(filter).toList();
      }
    }

    return orders;
  }

  static Future<SubCategory> subCategoryFromDocumentSnapshot(
    Category category,
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return await _subCategoryFromDocumentData(category, data);
  }

  static Future<SubCategory> subCategoryFromQueryDocumentSnapshot(
      Category category,
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return await _subCategoryFromDocumentData(category, data);
  }

  static Future<SubCategory> _subCategoryFromDocumentData(
      Category category, Map<String, dynamic> data) async {
    SubCategory subCategory = SubCategory(
      uid: data['uid'],
      name: data['name'],
      category: category,
    );

    return subCategory;
  }
}
