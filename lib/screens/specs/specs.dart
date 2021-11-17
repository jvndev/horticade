import 'package:flutter/material.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/specs/specs_list.dart';
import 'package:horticade/services/database.dart';
import 'package:provider/provider.dart';

class Specs extends StatelessWidget {
  final SubCategory subCategory;
  final List<Spec> selectedSpecs;

  const Specs({
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
      builder: (context, widget) => SpecsList(
        selectedSpecs: selectedSpecs,
      ),
    );
  }
}
