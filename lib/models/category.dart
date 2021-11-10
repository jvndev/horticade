import 'package:horticade/models/sub_category.dart';

class Category {
  String? uid;
  final String name;
  final List<SubCategory> children;

  Category({
    this.uid,
    required this.name,
    required this.children,
  });

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is! Category) {
      return false;
    } else {
      return other.uid != null && uid != null
          ? other.uid!.compareTo(uid!) == 0
          : other.name.compareTo(name) == 0;
    }
  }
}
