import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/admin/sub_categories.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/types.dart';
import 'package:provider/provider.dart';

class CategoriesListItem extends StatefulWidget {
  final Category category;

  const CategoriesListItem({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoriesListItem> createState() => _CategoriesListItemState();
}

class _CategoriesListItemState extends State<CategoriesListItem> {
  final DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamProvider<Future<List<SubCategory>>>.value(
          value: DatabaseService.subCategoryStream(
            filters: <SubCategoryPredicate>[
              (e) => e.category == widget.category,
            ],
          ),
          initialData: Future(() => const <SubCategory>[]),
          builder: (context, widget) =>
              SubCategories(category: this.widget.category),
        ),
      ],
    );
  }
}
