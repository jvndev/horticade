import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/category_dao.dart';
import 'package:horticade/db/entity_dao.dart';
import 'package:horticade/db/order_dao.dart';
import 'package:horticade/db/product_dao.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/entity.dart';
import 'package:horticade/models/location.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/types.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Entity?> findEntity(String uid) async {
    List<Entity> ret = [];
    QuerySnapshot<Map<String, dynamic>> qs =
        await _firestore.collection('entities').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> entityDocumentSnapshots =
        qs.docs.where((QueryDocumentSnapshot qds) => qds.id == uid).toList();

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot
        in entityDocumentSnapshots) {
      ret.add(await EntityDao.entityFromQueryDocumentSnapshot(snapshot));
    }
    return ret.isEmpty ? null : ret.first;
  }

  Future<Category?> createCategory(Category category) async {
    DocumentReference ref;

    try {
      await (ref = _firestore.collection('categories').doc())
          .set(category.toMap())
          .timeout(awaitTimeout);
      category.uid = ref.id;
    } catch (e) {
      return null;
    }

    return category;
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
      DocumentReference categoryRef =
          _firestore.collection('categories').doc(product.category.uid);
      DocumentReference productRef =
          _firestore.collection('products').doc(product.uid);

      productRef.set({
        'owner_uid': product.ownerUid,
        'name': product.name,
        'cost': product.cost,
        'image_filename': product.imageFilename,
        'qty': product.qty,
        'category': categoryRef,
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
}
