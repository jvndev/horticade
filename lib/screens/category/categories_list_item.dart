import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/subcategory_list_item.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:horticade/theme/horticade_theme.dart';

class CategoriesListItem extends StatefulWidget {
  final Category category;

  const CategoriesListItem({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoriesListItem> createState() => _CategoriesListItemState();
}

class _CategoriesListItemState extends State<CategoriesListItem> {
  final DatabaseService databaseService = DatabaseService();
  List<Widget> subCategories = [];
  ListTile? subCategoryAdd;
  bool expanded = false;

  Future<void> addSubCategory(SubCategory subCategory) async {
    SubCategory? retSubCategory =
        await databaseService.createSubCategory(subCategory);

    if (retSubCategory != null) {
      widget.category.children.add(retSubCategory);

      setState(() {
        populateSubCategories();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => HorticadeConfirmationDialog(
          title: 'Failed to add subcategory',
          accept: () {},
        ),
      );
    }
  }

  void populateSubCategories() {
    setState(() {
      subCategories = widget.category.children
          .map((e) => ListTile(
                title: Text(
                  e.name,
                  style: HorticadeTheme.cardTitleTextStyle,
                ),
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    populateSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        collapsedBackgroundColor: HorticadeTheme.expandedListCollapsedColor,
        backgroundColor: HorticadeTheme.expandedListColor,
        collapsedIconColor: HorticadeTheme.expandedListColor,
        iconColor: HorticadeTheme.expandedListCollapsedColor,
        initiallyExpanded: expanded,
        title: Text(
          widget.category.name,
          style: HorticadeTheme.expandedListTextStyle,
        ),
        subtitle: TextButton.icon(
          onPressed: () {
            setState(() {
              expanded = true;
              if (subCategoryAdd == null) {
                subCategoryAdd = SubCategoryListItem(
                  category: widget.category,
                  onAdd: (subCategory) {
                    addSubCategory(subCategory);
                    if (mounted) {
                      setState(() {
                        subCategories.remove(subCategoryAdd);
                        subCategoryAdd = null;
                      });
                    }
                  },
                ).build(context) as ListTile;

                subCategories.add(subCategoryAdd!);
              }
            });
          },
          label: const Text(
            'Add Subcategory',
            style: HorticadeTheme.expandedListAddTextStyle,
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 2.5),
        children: subCategories,
      ),
    );
  }
}
