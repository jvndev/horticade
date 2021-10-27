import 'package:firebase/models/category.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_button.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final DatabaseService db = DatabaseService();

  List<Category> _categories = [];

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
      String status = '';

      setState(() {
        _busy = true;
      });

      Category? category = await db.createCategory(Category(
        name: nameController.text,
      ));

      setState(() {
        _busy = false;
        nameController.text = '';

        if (category != null) {
          _categories.add(category);
          status = 'Category created successfully';
        } else {
          status = 'Failed to create category';
        }
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(status),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _busy = true;
    db.categories.then((categories) {
      setState(() {
        _categories = categories;
        _busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Card> categoryCards = _categories
        .map((category) => Card(
              child: ListTile(
                title: Text(category.name),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View/Edit Categories'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) => categoryCards[i],
                itemCount: categoryCards.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    decoration: textFieldDecoration('Category Name'),
                    validator: _categoryValidator,
                    controller: nameController,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _busy
                      ? Loader(
                          color: Colors.orange,
                          background: HorticadeTheme.scaffoldBackground!,
                        )
                      : HorticadeButton(
                          onPressed: _createCategory,
                          label: 'Save',
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
