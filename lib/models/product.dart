import 'package:firebase/models/category.dart';
import 'package:firebase/models/dao.dart';

class Product extends Dao implements Comparable<Product> {
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
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }
}
