import 'package:horticade/models/sub_category.dart';

class Spec<T> {
  String? uid;
  final String name;
  final T value;
  final SubCategory subCategory;

  Spec({
    this.uid,
    required this.name,
    required this.value,
    required this.subCategory,
  });
}
