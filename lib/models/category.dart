import 'package:horticade/models/dao.dart';

class Category extends Dao {
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
