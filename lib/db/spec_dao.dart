import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/sub_category_dao.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/shared/types.dart';

class SpecDao {
  static Future<List<Spec>> specFromQuerySnapshot({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    List<SpecPredicate>? filters,
  }) async {
    List<Spec> specs = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      specs.add(await SpecDao.specFromQueryDocumentSnapshot(snapshot: qds));
    }

    if (filters != null) {
      for (SpecPredicate filter in filters) {
        specs = specs.where(filter).toList();
      }
    }

    return specs;
  }

  static Future<Spec> specFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return _specFromDocumentData(data: data);
  }

  static Future<Spec> specFromQueryDocumentSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return _specFromDocumentData(data: data);
  }

  static Future<Spec> _specFromDocumentData(
      {required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> subCategoryRef =
        data['sub_category'];
    DocumentSnapshot<Map<String, dynamic>> subCategorySnapshot =
        await subCategoryRef.get();

    Spec spec = Spec(
      uid: data['uid'],
      name: data['name'],
      value: data['value'],
      subCategory: await SubCategoryDao.subCategoryFromDocumentSnapshot(
        subCategorySnapshot,
      ),
    );

    return spec;
  }
}
