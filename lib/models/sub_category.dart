import 'package:horticade/models/category.dart';

class SubCategory {
  String? uid;
  final String name;
  final Category? category; // the parent

  SubCategory({
    this.uid,
    required this.name,
    required this.category,
  });

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is! SubCategory) {
      return false;
    } else {
      return other.uid != null && uid != null
          ? other.uid!.compareTo(uid!) == 0
          : other.name.compareTo(name) == 0;
    }
  }
}
