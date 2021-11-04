import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/theme/horticade_theme.dart';

class CategoriesListItem extends StatelessWidget {
  final Category category;

  const CategoriesListItem({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: HorticadeTheme.cardColor,
        title: Text(category.name,
            style: const TextStyle(
              color: Colors.orange,
            )),
      ),
    );
  }
}
