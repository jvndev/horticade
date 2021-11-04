import 'package:flutter/material.dart';
import 'package:horticade/models/category.dart';

class CategoriesDropdownMenuItem extends DropdownMenuItem<Category> {
  CategoriesDropdownMenuItem(
    Category category, {
    Key? key,
  }) : super(
          key: key,
          value: category,
          child: Text(category.name),
        );
}
