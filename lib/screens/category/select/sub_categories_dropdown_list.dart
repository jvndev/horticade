import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class SubCategoriesDropdownList extends StatefulWidget {
  final VoidNullSubCategoryFunc onSelect;

  const SubCategoriesDropdownList({Key? key, required this.onSelect})
      : super(key: key);

  @override
  State<SubCategoriesDropdownList> createState() =>
      _SubCategoriesDropdownListState();
}

class _SubCategoriesDropdownListState extends State<SubCategoriesDropdownList> {
  SubCategory? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubCategory>>(
        future: Provider.of<Future<List<SubCategory>>>(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Loader(
              color: Colors.orange,
              background: HorticadeTheme.scaffoldBackground!,
            );
          } else {
            List<SubCategory> subCategories = snapshot.data!;

            return DropdownButtonFormField<SubCategory>(
              key: Key(
                  'sub_categories_dropdown_list_${Random().nextInt(99999999)}'),
              decoration: const InputDecoration(
                label: Text('Subcategory'),
              ),
              hint: const Text('Choose a Subcategory'),
              value: selectedSubCategory,
              items: subCategories
                  .map<DropdownMenuItem<SubCategory>>((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              isExpanded: false,
              onChanged: (subCategory) {
                widget.onSelect(subCategory);

                setState(() {
                  selectedSubCategory = subCategory;
                });
              },
            );
          }
        });
  }
}
