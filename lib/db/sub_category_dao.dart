import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/category_dao.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/types.dart';

class SubCategoryDao {
  static final DatabaseService databaseService = DatabaseService();

  static Future<List<SubCategory>> subCategoryFromQuerySnapshot({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    List<SubCategoryPredicate>? filters,
  }) async {
    List<SubCategory> orders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      orders.add(await subCategoryFromQueryDocumentSnapshot(qds));
    }

    if (filters != null) {
      for (SubCategoryPredicate filter in filters) {
        orders = orders.where(filter).toList();
      }
    }

    return orders;
  }

  static Future<SubCategory> subCategoryFromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return await _subCategoryFromDocumentData(data);
  }

  static Future<SubCategory> subCategoryFromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return await _subCategoryFromDocumentData(data);
  }

  static Future<SubCategory> _subCategoryFromDocumentData(
    Map<String, dynamic> data,
  ) async {
    DocumentReference<Map<String, dynamic>> categoryRef = data['category'];
    Category category =
        await CategoryDao.categoryFromDocumentSnapshot(await categoryRef.get());

    return SubCategory(
      uid: data['uid'],
      name: data['name'],
      category: category,
    );
  }
}
