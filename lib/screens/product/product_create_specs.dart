import 'package:flutter/material.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/product/product_create_specs_list.dart';
import 'package:horticade/services/database.dart';
import 'package:provider/provider.dart';

class ProductCreateSpecs extends StatelessWidget {
  final SubCategory subCategory;
  final List<Spec> selectedSpecs;

  const ProductCreateSpecs({
    Key? key,
    required this.subCategory,
    required this.selectedSpecs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<Spec>>>.value(
      value: DatabaseService.specStream(
        filters: [
          (spec) => spec.subCategory == subCategory,
        ],
      ),
      initialData: Future(() => const []),
      builder: (context, widget) => ProductCreateSpecsList(
        selectedSpecs: selectedSpecs,
      ),
    );
  }
}
