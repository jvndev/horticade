import 'package:horticade/models/category.dart';
import 'package:horticade/screens/category/admin/categories_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  final List<Category> _categories = [];

  String? _categoryValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Category name is required';
    }

    for (Category category in _categories) {
      if (category.name == val) {
        return 'Category $val already exists';
      }
    }
  }

  bool _busy = false;

  Future<void> _createCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _busy = true;
      });

      Category? category = await databaseService.createCategory(Category(
        name: nameController.text,
      ));

      setState(() {
        _busy = false;
        nameController.text = '';

        if (category != null) {
          _categories.add(category);
        } else {
          showDialog(
            context: context,
            builder: (context) => HorticadeConfirmationDialog(
              title: 'Category failed to create',
              accept: () {
                Navigator.of(context).pop();
              },
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<Category>>>.value(
      value: DatabaseService.categoryStream(),
      initialData: Future(() => const []),
      builder: (context, widget) => Scaffold(
        appBar: HorticadeAppBar(title: 'View/Edit Categories'),
        backgroundColor: HorticadeTheme.scaffoldBackground,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: TextFormField(
                          decoration: textFieldDecoration('New Category Name'),
                          validator: _categoryValidator,
                          controller: nameController,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: _busy
                          ? Loader(
                              color: Colors.orange,
                              background: HorticadeTheme.scaffoldBackground!,
                            )
                          : ElevatedButton(
                              onPressed: _createCategory,
                              style: HorticadeTheme.actionButtonTheme,
                              child: const Text(
                                'Add',
                                style: HorticadeTheme.actionButtonTextStyle,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: CategoriesList(key: Key('categories')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
