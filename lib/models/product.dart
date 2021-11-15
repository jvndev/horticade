import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';

class Product implements Comparable<Product> {
  String? uid;
  final String ownerUid;
  final String name;
  final double cost;
  final SubCategory subCategory;
  final String imageFilename;
  int qty;
  final List<Spec> specs;

  Product({
    this.uid,
    required this.ownerUid,
    required this.name,
    required this.cost,
    required this.subCategory,
    required this.imageFilename,
    required this.qty,
    required this.specs,
  });

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }
}
