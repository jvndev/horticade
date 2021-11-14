import 'package:flutter/material.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/admin/specs_bottom_sheet_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class SpecsBottomSheet extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final SubCategory subCategory;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  SpecsBottomSheet({
    Key? key,
    required this.subCategory,
  }) : super(key: key);

  Future<void> _createSpec() async {
    Spec? spec = await databaseService.createSpec(Spec(
      name: nameController.text,
      value: valueController.text,
      subCategory: subCategory,
    ));

    if (spec != null) {
      toast('Subcategory specification created.');
      nameController.text = '';
      valueController.text = '';
    } else {
      toast('Failed to create specification.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BottomSheet(
          enableDrag: false,
          onClosing: () {},
          shape: HorticadeTheme.bottomSheetShape,
          builder: (context) => Container(
            decoration: HorticadeTheme.bottomSheetDecoration,
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: HorticadeTheme.bottomSheetIconColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Spec name is required.';
                              }

                              return null;
                            },
                            controller: nameController,
                            decoration: textFieldDecoration('Spec Name'),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Spec value is required.';
                              }

                              return null;
                            },
                            controller: valueController,
                            decoration: textFieldDecoration('Spec Value'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: HorticadeTheme.bottomSheetActionButtonTheme,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _createSpec();
                              }
                            },
                            child: const Text(
                              'Add',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamProvider<Future<List<Spec>>>.value(
                  value: DatabaseService.specStream(
                    filters: <SpecPredicate>[
                      (spec) => spec.subCategory == subCategory,
                    ],
                  ),
                  initialData: Future(() => const []),
                  builder: (context, widget) => SpecsBottomSheetList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
