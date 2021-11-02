import 'package:horticade/models/dao.dart';

class Category extends Dao implements Comparable<Category> {
  final String name;

  Category({
    required this.name,
  });

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
      };

  @override
  String toString() {
    return '${super.uid} $name';
  }

  @override
  int compareTo(other) => name.compareTo(other.name);
}
