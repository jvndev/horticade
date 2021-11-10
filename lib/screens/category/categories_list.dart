import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/screens/category/categories_list_item.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: Provider.of<Future<List<Category>>>(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        } else {
          List<Category> categories = snapshot.data!;

          return ListView.separated(
            key: Key('${key}_categories_${categories.length}'),
            separatorBuilder: (context, i) => const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Divider(
                thickness: 2.0,
              ),
            ),
            itemBuilder: (context, i) =>
                CategoriesListItem(category: categories[i]),
            itemCount: categories.length,
          );
        }
      },
    );
  }
}
