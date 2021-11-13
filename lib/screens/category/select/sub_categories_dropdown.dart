import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/select/sub_categories_dropdown_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/types.dart';
import 'package:provider/provider.dart';

class SubCategoriesDropdown extends StatelessWidget {
  final Category category;
  final VoidNullSubCategoryFunc onSelect;

  const SubCategoriesDropdown({
    Key? key,
    required this.category,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<SubCategory>>>.value(
      value: DatabaseService.subCategoryStream(),
      initialData: Future(() => const <SubCategory>[]),
      builder: (context, widget) =>
          SubCategoriesDropdownList(onSelect: onSelect),
    );
  }
}
