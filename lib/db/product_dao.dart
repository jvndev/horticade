import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/sub_category_dao.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/shared/types.dart';

class ProductDao {
  static Future<List<Product>> productsFromQuerySnapshot({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    List<ProductPredicate>? filters,
  }) async {
    List<Product> products = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      products.add(
          await ProductDao.productFromQueryDocumentSnapshot(snapshot: qds));
    }

    if (filters != null) {
      for (ProductPredicate filter in filters) {
        products = products.where(filter).toList();
      }
    }

    return products;
  }

  static Future<Product> productFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return _productFromDocumentData(data: data);
  }

  static Future<Product> productFromQueryDocumentSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return _productFromDocumentData(data: data);
  }

  static Future<Product> _productFromDocumentData(
      {required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> subCategoryRef =
        data['sub_category'];
    DocumentSnapshot<Map<String, dynamic>> subCategorySnapshot =
        await subCategoryRef.get();

    Product product = Product(
      uid: data['uid'],
      ownerUid: data['owner_uid'],
      name: data['name'],
      cost: data['cost'],
      subCategory: await SubCategoryDao.subCategoryFromDocumentSnapshot(
        subCategorySnapshot,
      ),
      imageFilename: data['image_filename'],
      qty: data['qty'],
    );

    return product;
  }
}
