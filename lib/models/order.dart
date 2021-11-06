import 'package:horticade/models/location.dart';
import 'package:horticade/models/product.dart';

class Order {
  String? uid;
  final String clientUid;
  final String fulfillerUid; // owner of the product (product.owner)
  final Product product;
  final int qty;
  final bool fulfilled;
  final Location location;
  final DateTime created;
  final DateTime? deliverBy;

  Order({
    required this.clientUid,
    required this.fulfillerUid,
    required this.product,
    required this.qty,
    required this.fulfilled,
    required this.location,
    required this.created,
    required this.deliverBy,
  });
}
