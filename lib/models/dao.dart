import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/category.dart';
import 'package:firebase/models/location.dart';
import 'package:firebase/models/order.dart';
import 'package:firebase/models/product.dart';

abstract class Dao {
  String? uid;

  Dao({this.uid});

  Map<String, dynamic> toMap();

  static Future<Order> orderFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    DocumentReference<Map<String, dynamic>> productRef = data['product'];
    DocumentSnapshot<Map<String, dynamic>> productSnapshot =
        await productRef.get();

    Order order = Order(
      clientUid: data['client_uid'],
      fulfillerUid: data['fulfiller_uid'],
      product: await productFromDocumentSnapshot(productSnapshot),
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
    );
    order.uid = snapshot.id;

    return order;
  }

  static Future<Category> categoryFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    Category category = Category(name: data['name']);
    category.uid = snapshot.id;

    return category;
  }

  static Future<Product> productFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    DocumentReference<Map<String, dynamic>> categoryRef = data['category'];
    DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
        await categoryRef.get();

    Product product = Product(
      ownerUid: data['owner_uid'],
      name: data['name'],
      cost: data['cost'],
      category: await categoryFromDocumentSnapshot(categorySnapshot),
      imageFilename: data['image_filename'],
      qty: data['qty'],
    );
    product.uid = snapshot.id;

    return product;
  }
}
