import 'package:firebase/models/category.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/shared/types.dart';
import 'package:flutter/cupertino.dart';

class Filter with ChangeNotifier {
  final AuthUser authUser;
  final Map<String, ProductPredicate> filters = {};

  Filter({required this.authUser}) {
    filters['notOwned'] = (Product product) => product.ownerUid != authUser.uid;
    filters['name'] = (Product product) => true;
    filters['category'] = (Product product) => true;
    filters['fromPrice'] = (Product product) => true;
    filters['toPrice'] = (Product product) => true;
  }

  set name(String name) {
    filters['name'] = (Product product) => name.isEmpty
        ? true
        : product.name.toLowerCase().contains(name.toLowerCase());

    notifyListeners();
  }

  set category(Category? category) {
    filters['category'] = (Product product) =>
        category == null ? true : product.category.name == category.name;

    notifyListeners();
  }

  set fromPrice(String fromPrice) {
    filters['fromPrice'] = (Product product) =>
        fromPrice.isEmpty ? true : product.cost >= int.parse(fromPrice);

    notifyListeners();
  }

  set toPrice(String toPrice) {
    filters['toPrice'] = (Product product) =>
        toPrice.isEmpty ? true : product.cost <= int.parse(toPrice);

    notifyListeners();
  }

  List<ProductPredicate> get getFilters => filters.values.toList();
}
