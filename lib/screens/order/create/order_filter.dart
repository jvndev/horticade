import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/shared/types.dart';
import 'package:flutter/cupertino.dart';

class OrderFilter with ChangeNotifier {
  final AuthUser authUser;
  final Map<String, ProductPredicate> _filters = {};

  OrderFilter({required this.authUser}) {
    _filters['notOwned'] =
        (Product product) => product.ownerUid != authUser.uid;
    _filters['name'] = (Product product) => true;
    _filters['category'] = (Product product) => true;
    _filters['subCategory'] = (Product product) => true;
    _filters['fromPrice'] = (Product product) => true;
    _filters['toPrice'] = (Product product) => true;
  }

  set name(String name) {
    _filters['name'] = (Product product) => name.isEmpty
        ? true
        : product.name.toLowerCase().contains(name.toLowerCase());

    notifyListeners();
  }

  set category(Category? category) {
    _filters['category'] = (Product product) =>
        category == null ? true : product.subCategory.category == category;

    notifyListeners();
  }

  set subCategory(SubCategory? subCategory) {
    _filters['subCategory'] = (Product product) =>
        subCategory == null ? true : product.subCategory == subCategory;

    notifyListeners();
  }

  set fromPrice(double fromPrice) {
    _filters['fromPrice'] = (Product product) =>
        fromPrice == 0.0 ? true : product.cost >= fromPrice;

    notifyListeners();
  }

  set toPrice(double toPrice) {
    _filters['toPrice'] =
        (Product product) => toPrice == 0.0 ? true : product.cost <= toPrice;

    notifyListeners();
  }

  List<ProductPredicate> get filters => _filters.values.toList();
}
