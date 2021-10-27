import 'package:firebase/models/entity.dart';
import 'package:firebase/models/location.dart';
import 'package:firebase/models/order.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/location/location_search.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/services/location.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/image_loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase/shared/loader.dart';

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
  Location? deliveryLocation;
  DateTime? deliveryDate;
  String? _distance;
  bool _busy = false;

  @override
  void initState() {
    super.initState();

    imageService
        .retrieveImage(
      category: widget.product.category.name,
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
      });
      databaseService.findEntity(widget.product.ownerUid).then((owner) {
        setState(() {
          productOwner = owner;

          calculateDistance(owner!.location, entity!.location);
        });
      });
    });
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

  void _toggleDefaultAddress(bool? state) async {
    setState(() {
      _useDefaultAddress = state ?? true;
    });

    if (state != null && !state) {
      bool? ret = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delivery Address'),
          content: Column(
            children: [
              LocationSearch(onSelected: (location) {
                setState(() {
                  deliveryLocation = location;
                });
              }),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.greenAccent,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.check),
            ),
            IconButton(
              color: Colors.black,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
      );

      if (ret == null || !ret) {
        setState(() {
          _useDefaultAddress = true;
        });
      } else {
        calculateDistance(productOwner!.location, deliveryLocation!);
      }
    } else {
      calculateDistance(productOwner!.location, _entity!.location);
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
          _useDefaultAddress ? _entity!.location : deliveryLocation!;

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
        builder: (context) => AlertDialog(
          title: Text(orderStatus),
          actions: [
            IconButton(
              color: Colors.greenAccent,
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Order ${widget.product.name}'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Column(
            children: [
              _image ??
                  ImageLoader(
                    color: Colors.orange,
                    background: HorticadeTheme.scaffoldBackground!,
                  ),
              formTextSpacer,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Price: R${widget.product.cost}',
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
                  Expanded(
                    child: _distance != null
                        ? Text('$_distance away',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ))
                        : const Text('Calculating distance...'),
                  ),
                ],
              ),
              Form(
                key: _dailogFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Qty'),
                              hintText: 'Quantity to order',
                            ),
                            validator: (val) {
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
                            },
                            onChanged: (val) => _qty = val,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: DeliveryDateRow(
                            deliveryDate: deliveryDate,
                            set: _setDeliveryDate,
                            unset: () {
                              setState(() {
                                deliveryDate = null;
                              });
                            },
                          ),
                        ),
                      ],
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
                        _useDefaultAddress
                            ? Text('Deliver to: ${_entity?.location.address}')
                            : Text('Deliver to: ${deliveryLocation?.address}'),
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
                        child: ElevatedButton(
                          child: const Text(
                            'Cancel',
                            style: HorticadeTheme.actionButtonTextStyle,
                          ),
                          onPressed: () => Navigator.of(context).pop(null),
                          style: HorticadeTheme.actionButtonTheme,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: ElevatedButton(
                          child: const Text(
                            'Place Order',
                            style: HorticadeTheme.actionButtonTextStyle,
                          ),
                          onPressed: _placeOrder,
                          style: HorticadeTheme.actionButtonTheme,
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

class DeliveryDateRow extends StatelessWidget {
  final dynamic set;
  final dynamic unset;
  final DateTime? deliveryDate;

  const DeliveryDateRow(
      {Key? key, required this.deliveryDate, this.set, this.unset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deliveryDate == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Delivery Date'),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: set,
            child: const Text(
              'Set',
              style: HorticadeTheme.actionButtonTextStyle,
            ),
            style: HorticadeTheme.actionButtonTheme,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Req. delivery date: ${d(deliveryDate!)}'),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: unset,
            child: const Text('Unset'),
          ),
        ],
      );
    }
  }
}

class DeliveryAddress extends StatelessWidget {
  final bool useDefaultAddress;
  final dynamic toggleDefault;
  final dynamic addressChanged;

  const DeliveryAddress({
    Key? key,
    required this.useDefaultAddress,
    required this.toggleDefault,
    required this.addressChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
