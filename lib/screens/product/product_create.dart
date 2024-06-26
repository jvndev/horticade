import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/camera/camera.dart';
import 'package:horticade/screens/category/select/categories_dropdown.dart';
import 'package:horticade/screens/category/select/sub_categories_dropdown.dart';
import 'package:horticade/screens/specs/specs.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/services/image.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.isNotEmpty) {
      return TextEditingValue(
        text: '${text[0].toUpperCase()}' '${text.substring(1)}',
        selection: newValue.selection,
      );
    } else {
      return newValue;
    }
  }
}

class ProductCreate extends StatefulWidget {
  const ProductCreate({Key? key}) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImageService _imageService = ImageService();
  final DatabaseService db = DatabaseService();
  final CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(symbol: 'R');

  bool _saving = false;
  String _status = '';
  String? _imagePath;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  List<Spec> _selectedSpecs = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  Future<void> _snap() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Camera()))
        .then((imagePath) {
      setState(() {
        _imagePath = imagePath;
        _status = '';
      });
    });
  }

  Future<void> _createProduct() async {
    AuthUser authUser = Provider.of<AuthUser>(context, listen: false);

    if (_imagePath == null) {
      setState(() {
        _status = 'No product picture taken. Tap the image circle above.';
      });

      return;
    }

    if (_selectedSubCategory == null) {
      setState(() {
        _status = 'A product subcategory is required.';
      });

      return;
    }

    setState(() {
      _status = '';
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _status = '';
        _saving = true;
      });

      String? imageFilename = await _imageService.storeImage(
        uid: authUser.uid,
        localPath: _imagePath as String,
        subCategory: _selectedSubCategory!,
      );

      Product? product;
      if (imageFilename == null) {
        _status = "Failed to save image";

        return;
      } else {
        product = await db.createProduct(Product(
          ownerUid: authUser.uid,
          name: nameController.text,
          cost: currencyTextInputFormatter.getUnformattedValue().toDouble(),
          subCategory: _selectedSubCategory!,
          imageFilename: imageFilename,
          qty: int.parse(qtyController.text),
          specs: _selectedSpecs,
        ));
      }

      setState(() {
        _saving = false;
      });

      if (product == null) {
        _status = 'Unable to create product';
      } else {
        bool? again = await showDialog<bool>(
          context: context,
          builder: (context) => HorticadeConfirmationDialog(
            title: 'Product Created!',
            content: const Text('Create another product?'),
            accept: () => Navigator.of(context).pop(true),
            reject: () => Navigator.of(context).pop(false),
          ),
        );

        if (again != null && again) {
          setState(() {
            nameController.text = '';
            costController.text = '';
            qtyController.text = '';

            _imagePath = null;

            _selectedSpecs = [];
          });
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HorticadeAppBar(title: 'New Product'),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _snap,
                  child: CircleAvatar(
                    backgroundColor: HorticadeTheme.scaffoldBackground,
                    radius: 60.0,
                    backgroundImage: _imagePath != null
                        ? Image.file(File(_imagePath as String)).image
                        : Image.asset(HorticadeTheme.horticateLogo).image,
                  ),
                ),
                formImageSpacer,
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: formPadding,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (name) => name == null || name.isEmpty
                              ? 'Product name is required'
                              : null,
                          decoration: textFieldDecoration('Product Name'),
                          controller: nameController,
                          inputFormatters: <TextInputFormatter>[
                            NameTextFormatter(),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CategoriesDropdown(onSelect: (category) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              }),
                            ),
                          ],
                        ),
                        _selectedCategory != null
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: SubCategoriesDropdown(
                                      category: _selectedCategory!,
                                      onSelect: (subCategory) {
                                        setState(() {
                                          _selectedSubCategory = subCategory;
                                          _selectedSpecs = <Spec>[];
                                        });
                                      },
                                    ),
                                  ),
                                  _selectedSubCategory != null
                                      ? Expanded(
                                          flex: 5,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              _selectedSpecs =
                                                  await showDialog<List<Spec>>(
                                                        context: context,
                                                        builder: (context) {
                                                          return Specs(
                                                            selectedSpecs:
                                                                _selectedSpecs,
                                                            subCategory:
                                                                _selectedSubCategory!,
                                                          );
                                                        },
                                                      ) ??
                                                      _selectedSpecs;
                                            },
                                            icon: const Icon(
                                              Icons.link,
                                              color: Colors.orange,
                                            ),
                                            label: const Text(
                                              'Add Specs',
                                              style: HorticadeTheme
                                                  .actionButtonTextStyle,
                                            ),
                                            style: HorticadeTheme
                                                .actionButtonTheme,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox(),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 2.5, 0),
                                child: TextFormField(
                                  validator: (price) {
                                    if (price == null || price.isEmpty) {
                                      return 'Price is required';
                                    }

                                    return null;
                                  },
                                  decoration: textFieldDecoration('Price'),
                                  controller: costController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    currencyTextInputFormatter,
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
                                child: TextFormField(
                                  validator: (qty) {
                                    if (qty == null || qty.isEmpty) {
                                      return 'Qty is required';
                                    }

                                    if (!RegExp(r'^\d+$').hasMatch(qty)) {
                                      return 'Invalid quantity.';
                                    }

                                    return null;
                                  },
                                  decoration: textFieldDecoration('Qty'),
                                  controller: qtyController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                        formButtonSpacer,
                        _saving
                            ? Loader(
                                color: Colors.orange,
                                background: HorticadeTheme.scaffoldBackground!,
                              )
                            : Row(
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: 1.0,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: ElevatedButton(
                                      onPressed: _createProduct,
                                      child: const Text(
                                        'Create',
                                        style: HorticadeTheme
                                            .actionButtonTextStyle,
                                      ),
                                      style: HorticadeTheme.actionButtonTheme,
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                        Text(_status, style: errorTextStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
