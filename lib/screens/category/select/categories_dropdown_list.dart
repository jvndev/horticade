import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class CategoriesDropdownList extends StatefulWidget {
  final VoidCatetegoryFunc onSelect;
  Loader? loader;

  CategoriesDropdownList({Key? key, this.loader, required this.onSelect})
      : super(key: key);

  @override
  State<CategoriesDropdownList> createState() => _CategoriesDropdownListState();
}

class _CategoriesDropdownListState extends State<CategoriesDropdownList> {
  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    Loader loader = widget.loader ??
        Loader(
          color: Colors.orange,
          background: HorticadeTheme.scaffoldBackground!,
        );

    return FutureBuilder<List<Category>>(
        future: Provider.of<Future<List<Category>>>(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return loader;
          } else {
            List<Category> categories = snapshot.data!;

            return DropdownButtonFormField<Category>(
              key:
                  Key('categories_dropdown_list_${Random().nextInt(99999999)}'),
              decoration: const InputDecoration(
                label: Text('Category'),
              ),
              hint: const Text('Category'),
              value: selectedCategory,
              items: categories
                  .map<DropdownMenuItem<Category>>((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              isExpanded: false,
              onChanged: (category) {
                widget.onSelect(category);

                setState(() {
                  selectedCategory = category;
                });
              },
            );
          }
        });
  }
}
