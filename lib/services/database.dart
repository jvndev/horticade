import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/category_dao.dart';
import 'package:horticade/db/entity_dao.dart';
import 'package:horticade/db/order_dao.dart';
import 'package:horticade/db/product_dao.dart';
import 'package:horticade/db/spec_dao.dart';
import 'package:horticade/db/sub_category_dao.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/entity.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/types.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Entity> findEntity(String uid) async {
    return EntityDao.entityFromDocumentSnapshot(
            await _firestore.collection('entities').doc(uid).get())
        .timeout(awaitTimeout);
  }

  Future<Spec?> createSpec(Spec spec) async {
    try {
      DocumentReference subCategoryRef =
          _firestore.collection('sub_categories').doc(spec.subCategory.uid);

      DocumentReference specRef = await _firestore.collection('specs').add({
        'name': spec.name,
        'value': spec.value,
        'sub_category': subCategoryRef,
      }).timeout(awaitTimeout);
      spec.uid = specRef.id;

      return spec;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteSpec(Spec spec) async {
    try {
      await _firestore.collection('specs').doc(spec.uid).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<SubCategory?> createSubCategory(
    SubCategory subCategory,
  ) async {
    DocumentReference subCategoryRef;
    DocumentReference categoryRef =
        _firestore.collection('categories').doc(subCategory.category!.uid);

    try {
      await (subCategoryRef = _firestore.collection('sub_categories').doc())
          .set({
        'name': subCategory.name,
        'category': categoryRef,
      });
    } catch (e) {
      return null;
    }

    subCategory.uid = subCategoryRef.id;

    return subCategory;
  }

  Future<Category?> createCategory(Category category) async {
    DocumentReference categoriesRef;

    try {
      await (categoriesRef = _firestore.collection('categories').doc()).set({
        'name': category.name,
      }).timeout(awaitTimeout);
      category.uid = categoriesRef.id;
    } catch (e) {
      return null;
    }

    return category;
  }

  Future<List<SubCategory>> findSubcategories(Category category) async {
    List<SubCategory> ret = [];
    DocumentReference parentRef =
        _firestore.collection('categories').doc(category.uid);
    QuerySnapshot<Map<String, dynamic>> subCategoriesSnapshot = await _firestore
        .collection('sub_categories')
        .where('category', isEqualTo: parentRef)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds
        in subCategoriesSnapshot.docs) {
      ret.add(
        await SubCategoryDao.subCategoryFromQueryDocumentSnapshot(
          qds,
        ),
      );
    }

    return ret;
  }

  // entity uid will be the authuser's
  Future<Entity?> createEntity(Entity entity) async {
    try {
      await (_firestore.collection('entities').doc(entity.uid))
          .set(entity.toMap())
          .timeout(awaitTimeout);

      return entity;
    } catch (e) {
      return null;
    }
  }

  ///
  /// Images are stored under Firebase Storage as:
  /// <category>/image_filename.jpg
  ///
  Future<Product?> createProduct(Product product) async {
    try {
      DocumentReference subCategoryRef =
          _firestore.collection('sub_categories').doc(product.subCategory.uid);
      DocumentReference productRef =
          _firestore.collection('products').doc(product.uid);

      productRef.set({
        'owner_uid': product.ownerUid,
        'name': product.name,
        'cost': product.cost,
        'image_filename': product.imageFilename,
        'qty': product.qty,
        'sub_category': subCategoryRef,
        'specs': product.specs
            .map((e) => _firestore.collection('specs').doc(e.uid))
            .toList(),
      }).timeout(awaitTimeout);

      product.uid = productRef.id;

      return product;
    } catch (e) {
      return null;
    }
  }

  Future<Order?> createOrder(Order order, Product product) async {
    try {
      DocumentReference productRef =
          _firestore.collection('products').doc(order.product.uid);
      DocumentReference orderRef;

      orderRef = await _firestore.collection('orders').add({
        'client_uid': order.clientUid,
        'fulfiller_uid': order.fulfillerUid,
        'product': productRef,
        'qty': order.qty,
        'fulfilled': order.fulfilled,
        'address': order.location.address,
        'geocode': order.location.geocode,
        'created': order.created,
        'deliver_by': order.deliverBy,
      });

      order.uid = orderRef.id;

      product.qty -= order.qty;
      createProduct(product);

      return order;
    } catch (e) {
      return null;
    }
  }

  /////////////
  // Streams //
  /////////////

  static Stream<Future<List<Product>>> productStream(
          {List<ProductPredicate>? filters}) =>
      _firestore.collection('products').snapshots().map(
            (snapshot) => ProductDao.productsFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );

  static Stream<Future<List<Order>>> orderStream(
          {List<OrderPredicate>? filters}) =>
      _firestore.collection('orders').snapshots().map(
            (snapshot) => OrderDao.ordersFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );

  static Stream<Future<List<Category>>> categoryStream(
          {List<CategoryPredicate>? filters}) =>
      _firestore.collection('categories').snapshots().map(
            (snapshot) => CategoryDao.categoryFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );

  static Stream<Future<List<SubCategory>>> subCategoryStream(
          {List<SubCategoryPredicate>? filters}) =>
      _firestore.collection('sub_categories').snapshots().map(
            (snapshot) => SubCategoryDao.subCategoryFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );

  static Stream<Future<List<Spec>>> specStream(
          {List<SpecPredicate>? filters}) =>
      _firestore.collection('specs').snapshots().map(
            (snapshot) => SpecDao.specFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );
}
