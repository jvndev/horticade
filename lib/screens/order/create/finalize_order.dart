import 'package:horticade/models/entity.dart';
import 'package:horticade/models/location.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/location/location_search.dart';
import 'package:horticade/screens/order/create/delivery_date_row.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/services/image.dart';
import 'package:horticade/services/location.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/image_display.dart';
import 'package:horticade/shared/image_loader.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:horticade/shared/loader.dart';

class FinalizeOrder extends StatefulWidget {
  final Product product;
  final AuthUser authUser;

  const FinalizeOrder({Key? key, required this.product, required this.authUser})
      : super(key: key);

  @override
  State<FinalizeOrder> createState() => _FinalizeOrderState();
}

class _FinalizeOrderState extends State<FinalizeOrder> {
  final ImageService imageService = ImageService();
  final DatabaseService databaseService = DatabaseService();
  final LocationService locationService = LocationService();
  final GlobalKey<FormState> _dailogFormKey = GlobalKey<FormState>();

  Entity? _entity;
  Image? _image;
  String _qty = '';
  bool _useDefaultAddress = true;
  Entity? productOwner;
  Location? newDeliveryLocation;
  DateTime? deliveryDate;
  String? _distance;
  String? deliverTo;
  bool _busy = false;

  @override
  void initState() {
    super.initState();

    imageService
        .retrieveImage(
      subCategory: widget.product.subCategory.name,
      imageFilename: widget.product.imageFilename,
    )
        .then((image) {
      setState(() {
        _image = image;
      });
    });

    databaseService.findEntity(widget.authUser.uid).then((entity) {
      setState(() {
        _entity = entity;
        deliverTo = _entity!.location.address;
      });
      databaseService.findEntity(widget.product.ownerUid).then((owner) {
        setState(() {
          productOwner = owner;

          calculateDistance(owner.location, entity.location);
        });
      });
    });
  }

  void showImage() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageDisplay(image: _image!),
    ));
  }

  void calculateDistance(Location from, Location to) {
    setState(() {
      _distance = null;
    });

    locationService.distance(from, to).then((distance) {
      setState(() {
        _distance = distance;
      });
    });
  }

  void _toggleDefaultAddress(bool? useDefault) async {
    Location productLocation = productOwner!.location;

    setState(() {
      _useDefaultAddress = useDefault ?? true;
    });

    if (useDefault != null && !useDefault) {
      bool? ret = await showDialog(
        context: context,
        builder: (context) => HorticadeConfirmationDialog(
          title: 'Delivery Address',
          content: Column(
            children: [
              LocationSearch(onSelected: (location) {
                setState(() {
                  newDeliveryLocation = location;
                });
              }),
            ],
          ),
          accept: () => Navigator.of(context).pop(true),
          reject: () => Navigator.of(context).pop(false),
        ),
      );

      if (ret == null || !ret) {
        setState(() {
          _useDefaultAddress = true;
        });
      } else {
        calculateDistance(productLocation, newDeliveryLocation!);
        setState(() {
          deliverTo = newDeliveryLocation!.address;
        });
      }
    } else {
      calculateDistance(productLocation, _entity!.location);
      setState(() {
        deliverTo = _entity!.location.address;
      });
    }
  }

  Future<void> _setDeliveryDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 356),
      ),
      builder: (BuildContext context, Widget? child) => Theme(
        data: ThemeData(
          primarySwatch: HorticadeTheme.calenderColorSwatch,
          primaryColor: HorticadeTheme.datePickerPrimary,
          canvasColor: HorticadeTheme.datePickerPrimary,
          scaffoldBackgroundColor: HorticadeTheme.datePickerPrimary,
        ),
        child: child!,
      ),
    );

    setState(() {
      deliveryDate = picked;
    });
  }

  Future<void> _placeOrder() async {
    if (_dailogFormKey.currentState!.validate()) {
      Location location =
          _useDefaultAddress ? _entity!.location : newDeliveryLocation!;

      Order order = Order(
        clientUid: widget.authUser.uid,
        fulfillerUid: widget.product.ownerUid,
        product: widget.product,
        qty: int.parse(_qty),
        fulfilled: false,
        location: location,
        created: DateTime.now(),
        deliverBy: deliveryDate,
      );

      setState(() {
        _busy = true;
      });

      Order? placedOrder =
          await databaseService.createOrder(order, widget.product);
      String orderStatus =
          placedOrder == null ? 'Failed to create order' : 'Order Placed';

      setState(() {
        _busy = false;
      });

      await showDialog(
        context: context,
        builder: (context) => HorticadeConfirmationDialog(
          title: orderStatus,
          accept: () {
            Navigator.of(context).pop();
          },
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? orderValidator(val) {
      if (val == null || val.isEmpty) {
        return 'Qty Required';
      } else if (!RegExp(r'^\d+$').hasMatch(val)) {
        return 'Invalid Qty';
      } else if (int.parse(val) <= 0) {
        return 'Cannot be 0';
      } else if (widget.product.qty <= 0) {
        return 'Item is out of stock';
      } else if (int.parse(val) > widget.product.qty) {
        return 'Qty is more than in stock';
      }

      return null;
    }

    return Scaffold(
      appBar: HorticadeAppBar(title: 'Order ${widget.product.name}'),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Column(
            children: [
              _image != null
                  ? GestureDetector(child: _image!, onTap: showImage)
                  : ImageLoader(
                      color: Colors.orange,
                      background: HorticadeTheme.scaffoldBackground!,
                    ),
              formTextSpacer,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Price: ${c(widget.product.cost)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.product.qty > 0
                        ? Text('In stock: ${widget.product.qty}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ))
                        : const Text(
                            'Out of stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
              Form(
                key: _dailogFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Order Quantity'),
                      ),
                      validator: orderValidator,
                      onChanged: (val) => _qty = val,
                    ),
                    formTextSpacer,
                    DeliveryDateRow(
                      deliveryDate: deliveryDate,
                      set: _setDeliveryDate,
                      unset: () {
                        setState(() {
                          deliveryDate = null;
                        });
                      },
                    ),
                    Column(
                      children: [
                        productOwner == null
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Text('Default delivery address'),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Checkbox(
                                      value: _useDefaultAddress,
                                      onChanged: _toggleDefaultAddress,
                                      activeColor:
                                          HorticadeTheme.checkBoxActive,
                                    ),
                                  ),
                                ],
                              ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Deliver to',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  deliverTo == null
                                      ? Loader(
                                          color: Colors.orange,
                                          background: HorticadeTheme
                                              .scaffoldBackground!,
                                        )
                                      : Text(deliverTo!),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: _distance != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Distance',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text(_distance!),
                                      ],
                                    )
                                  : Loader(
                                      color: Colors.orange,
                                      background:
                                          HorticadeTheme.scaffoldBackground!,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              formTextSpacer,
              _busy
                  ? Loader(
                      color: Colors.orange,
                      background: HorticadeTheme.scaffoldBackground!,
                    )
                  : Row(children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 2.5, 0),
                          child: ElevatedButton(
                            child: const Text(
                              'Cancel',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                            onPressed: () => Navigator.of(context).pop(null),
                            style: HorticadeTheme.actionButtonTheme,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
                          child: ElevatedButton(
                            child: const Text(
                              'Place Order',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                            onPressed: _placeOrder,
                            style: HorticadeTheme.actionButtonTheme,
                          ),
                        ),
                      ),
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
