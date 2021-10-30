import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/db/order_dao.dart';
import 'package:firebase/db/product_dao.dart';
import 'package:firebase/models/category.dart';
import 'package:firebase/models/entity.dart';
import 'package:firebase/models/location.dart';
import 'package:firebase/models/order.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/types.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<List<Category>> get categories async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('categories').get().timeout(awaitTimeout);

    return snapshot.docs.map((snapshot) {
      Category category = Category(name: snapshot.data()['name']);
      category.uid = snapshot.id;

      return category;
    }).toList();
  }

  Future<List<Entity>> _findEntities(find) async {
    List<Entity> ret = [];
    QuerySnapshot qs = await _firestore.collection('entities').get();

    var entityDocumentSnapshots = qs.docs.where(find);

    for (var snapshot in entityDocumentSnapshots) {
      Map entityData = snapshot.data() as Map<String, dynamic>;

      ret.add(Entity(
        uid: snapshot.id,
        name: entityData['name'],
        location: Location(
          address: entityData['address'],
          geocode: entityData['geocode'],
        ),
      ));
    }

    return ret;
  }

  Future<Entity?> findEntity(String uid) async {
    List<Entity> ret =
        await _findEntities((QueryDocumentSnapshot qds) => qds.id == uid);

    return ret.isEmpty ? null : ret.first;
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

  Future<List<Product>> findProductsByOwner(String uid) async {
    List<Product> ret = [];
    List<Category> _categories = await categories;

    for (Category category in _categories) {
      List<Product> _products =
          await _findProducts(category, (QueryDocumentSnapshot qds) {
        Map data = qds.data() as Map<String, dynamic>;

        return data['owner_uid'] == uid;
      });

      ret.addAll(_products);
    }

    return ret;
  }

  Future<List<Product>> findProductsByNameExcludeOwned(
          Category category, String name, String ownerUid) =>
      _findProducts(
        category,
        (QueryDocumentSnapshot qds) {
          Map data = qds.data() as Map<String, dynamic>;
          String productName = (data['name'] as String).trim().toLowerCase();

          if (data['owner_uid'] == ownerUid) {
            return false;
          }

          return name.isEmpty ? true : productName.contains(name.toLowerCase());
        },
      );

  Future<List<Product>> _findProducts(Category category, find) async {
    QuerySnapshot productsSnapshot =
        await _firestore.collection('products').get();
    DocumentReference categoryRef =
        _firestore.collection('categories').doc(category.uid);

    return productsSnapshot.docs
        .where((QueryDocumentSnapshot qds) {
          Map data = qds.data() as Map<String, dynamic>;

          return data['category'] == categoryRef;
        })
        .where(find)
        .map((QueryDocumentSnapshot qds) {
          Map data = qds.data() as Map<String, dynamic>;

          Product product = Product(
            ownerUid: data['owner_uid'],
            name: data['name'],
            cost: data['cost'],
            category: category,
            imageFilename: data['image_filename'],
            qty: data['qty'],
          );
          product.uid = qds.id;

          return product;
        })
        .toList();
  }

  Future<List<Order>> sentOrders(String uid) async {
    List<Order> orders = [];
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await _firestore
        .collection('orders')
        .where('client_uid', isEqualTo: uid)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> orderSnapshot
        in ordersSnapshot.docs) {
      Map data = orderSnapshot.data();
      DocumentReference<Map<String, dynamic>> productRef = data['product'];

      orders.add(Order(
        clientUid: data['client_uid'],
        fulfillerUid: data['fulfiller_uid'],
        product: await ProductDao.productFromDocumentSnapshot(
            await productRef.get()),
        qty: data['qty'],
        fulfilled: data['fulfilled'],
        location: Location(
          address: data['address'],
          geocode: data['geocode'],
        ),
        created: (data['created'] as Timestamp).toDate(),
        deliverBy: data['deliver_by'] == null
            ? null
            : (data['deliver_by'] as Timestamp).toDate(),
      ));
    }

    return orders;
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


  // Streams //

  Stream<Future<List<Product>>> productStream(
          {List<ProductPredicate>? filters}) =>
      _firestore.collection('products').snapshots().map(
            (snapshot) => ProductDao.productsFromQuerySnapshot(
              snapshot: snapshot,
              filters: filters,
            ),
          );

  Stream<Future<List<Order>>> pendingOrderStream({OrderPredicate? filter}) =>
      _firestore.collection('orders').snapshots().map(
            (snapshot) => OrderDao.ordersFromQuerySnapshot(
              snapshot: snapshot,
              filter: filter,
            ),
          );
}
