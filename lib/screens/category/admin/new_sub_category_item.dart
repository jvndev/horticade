import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';

class NewSubCategoryItem extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final VoidSubCategoryFunc onAdd;
  final Category category; //parent

  NewSubCategoryItem({
    Key? key,
    required this.category,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: TextFormField(
              controller: nameController,
              decoration: textFieldDecoration('New Subcategory Name'),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Subcategory name is required';
                }

                return null;
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              style: HorticadeTheme.actionButtonTheme,
              child: const Text(
                'Add',
                style: HorticadeTheme.actionButtonTextStyle,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  onAdd(SubCategory(
                    name: nameController.text,
                    category: category,
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
