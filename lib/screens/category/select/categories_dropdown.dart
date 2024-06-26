import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/screens/category/select/'
    'categories_dropdown_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/shared/types.dart';
import 'package:provider/provider.dart';

class CategoriesDropdown extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final VoidCatetegoryFunc onSelect;
  Loader? loader;

  CategoriesDropdown({Key? key, this.loader, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<Category>>>.value(
      value: DatabaseService.categoryStream(),
      initialData: Future(() => const []),
      builder: (context, widget) => CategoriesDropdownList(
        onSelect: onSelect,
        loader: loader,
      ),
    );
  }
}
