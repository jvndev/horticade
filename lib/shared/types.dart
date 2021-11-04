import 'package:horticade/models/category.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';

typedef VoidFunc = void Function();
typedef OrderPredicate = bool Function(Order);
typedef ProductPredicate = bool Function(Product);
typedef NullCatetegoryVoidFunc = void Function(Category?);
typedef CategoryPredicate = bool Function(Category);
