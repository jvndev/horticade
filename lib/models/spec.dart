import 'package:horticade/models/sub_category.dart';

class Spec<T> implements Comparable<Spec> {
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

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is! Spec) {
      return false;
    } else {
      return other.uid != null && uid != null
          ? other.uid!.compareTo(uid!) == 0
          : other.name.compareTo(name) == 0 && other.value == value;
    }
  }

  @override
  int compareTo(other) {
    if (other.uid != null && uid != null) {
      return uid!.compareTo(other.uid!);
    }

    if (other.name != name) {
      return name.compareTo(other.name);
    }

    if (other.value is num && value is num) {
      return (value as num).compareTo(other.value);
    }

    if (other.value is String && value is String) {
      return (value as String).compareTo(other.value);
    }

    if (other.value is bool && value is bool) {
      if (other.value == value) {
        return 0;
      } else if (value == true) {
        return 1;
      } else {
        return -1;
      }
    }

    return 1;
  }

  @override
  String toString() {
    return '$uid $name $value';
  }
}
