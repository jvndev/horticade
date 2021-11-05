import 'package:flutter/cupertino.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/shared/types.dart';

class ProductFilter with ChangeNotifier {
  ProductFilter({required AuthUser authUser}) {
    _filters['owned'] = (product) => product.ownerUid == authUser.uid;
  }

  final _filters = <String, ProductPredicate>{
    'owned': (product) => true,
    'name': (product) => true,
  };

  set name(String name) {
    _filters['name'] =
        (product) => product.name.toLowerCase().contains(name.toLowerCase());

    notifyListeners();
  }

  List<ProductPredicate> get filters => _filters.values.toList();
}
