import 'package:horticade/models/category.dart';

class Product implements Comparable<Product> {
  String? uid;
  final String ownerUid;
  final String name;
  final double cost;
  final Category category;
  final String imageFilename;
  int qty;

  Product({
    required this.ownerUid,
    required this.name,
    required this.cost,
    required this.category,
    required this.imageFilename,
    required this.qty,
  });

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }
}
