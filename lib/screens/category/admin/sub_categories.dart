import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/admin/new_sub_Category_item.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class SubCategories extends StatefulWidget {
  final Category category;

  const SubCategories({key, required this.category}) : super(key: key);

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final DatabaseService databaseService = DatabaseService();
  Form? subCategoryAdd;
  bool isExpanded = false;

  Future<void> addSubCategory(SubCategory subCategory) async {
    SubCategory? retSubCategory =
        await databaseService.createSubCategory(subCategory);

    if (retSubCategory == null) {
      showDialog(
        context: context,
        builder: (context) => HorticadeConfirmationDialog(
          title: 'Failed to add subcategory',
          accept: () {},
        ),
      );
    } else {
      isExpanded = true;
    }
  }

  ExpansionPanelList subCategoryList(
    Category category,
    List<SubCategory> subCategories,
  ) {
    return ExpansionPanelList(
      expansionCallback: (i, state) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: HorticadeTheme.expansionPanelHeaderColor,
          headerBuilder: (context, isExpanded) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: HorticadeTheme.expansionPanelTextStyle,
              ),
              subCategoryAdd == null
                  ? TextButton.icon(
                      onPressed: () {
                        setState(() {
                          subCategoryAdd ??= NewSubCategoryItem(
                            category: widget.category,
                            onAdd: (subCategory) {
                              addSubCategory(subCategory);
                              setState(() {
                                subCategoryAdd = null;
                              });
                            },
                          ).build(context) as Form;
                        });
                      },
                      label: const Text(
                        'Add Subcategory',
                        style: HorticadeTheme.expansionAddTextStyle,
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : subCategoryAdd!,
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subCategories.map((e) => Text(e.name)).toList(),
          ),
          isExpanded: isExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubCategory>>(
      initialData: const <SubCategory>[],
      future: Provider.of<Future<List<SubCategory>>>(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        } else {
          List<SubCategory> subCategories = snapshot.data!;
          return Column(
            children: [
              subCategoryList(widget.category, subCategories),
            ],
          );
        }
      },
    );
  }
}
