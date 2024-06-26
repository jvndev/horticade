import 'package:horticade/models/category.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';

typedef VoidFunc = void Function();
typedef OrderPredicate = bool Function(Order);
typedef VoidProductFunc = void Function(Product);
typedef ProductPredicate = bool Function(Product);
typedef VoidCatetegoryFunc = void Function(Category?);
typedef CategoryPredicate = bool Function(Category);
typedef SubCategoryPredicate = bool Function(SubCategory);
typedef VoidSubCategoryFunc = void Function(SubCategory);
typedef VoidNullSubCategoryFunc = void Function(SubCategory?);
typedef SpecPredicate = bool Function(Spec);
typedef VoidSpecListFunc = void Function(List<Spec>);
