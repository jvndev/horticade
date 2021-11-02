import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horticade/db/product_dao.dart';
import 'package:horticade/models/location.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/shared/types.dart';

class OrderDao {
  static Future<List<Order>> ordersFromQuerySnapshot({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    OrderPredicate? filter,
  }) async {
    List<Order> orders = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> qds in snapshot.docs) {
      orders.add(await orderFromQueryDocumentSnapshot(qds));
    }

    if (filter != null) {
      orders = orders.where(filter).toList();
    }

    return orders;
  }

  static Future<Order> orderFromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data();

    data['uid'] = snapshot.id;

    return await _orderFromDocumentData(data);
  }

  static Future<Order> orderFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    Map<String, dynamic> data = snapshot.data()!;

    data['uid'] = snapshot.id;

    return await _orderFromDocumentData(data);
  }

  static Future<Order> _orderFromDocumentData(Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> productRef = data['product'];
    DocumentSnapshot<Map<String, dynamic>> productSnapshot =
        await productRef.get();

    Order order = Order(
      clientUid: data['client_uid'],
      fulfillerUid: data['fulfiller_uid'],
      product: await ProductDao.productFromDocumentSnapshot(productSnapshot),
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
    order.uid = data['uid'];

    return order;
  }
}
