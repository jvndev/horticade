import 'package:horticade/models/location.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/services/location.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_order_line.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final LocationService locationService = LocationService();
  final DatabaseService databaseService = DatabaseService();

  String? _distance;

  @override
  void initState() {
    super.initState();

    databaseService.findEntity(widget.order.product.ownerUid).then((entity) {
      Location productLocation = entity!.location;
      Location orderLocation = widget.order.location;

      locationService.distance(productLocation, orderLocation).then((distance) {
        setState(() {
          _distance = distance;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Details'),
        backgroundColor: HorticadeTheme.appbarBackground,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Column(
        children: [
          formTextSpacer,
          HorticadeOrderLine(
            heading: 'Category',
            details: widget.order.product.category.name,
          ),
          HorticadeOrderLine(
            heading: 'Product',
            details: widget.order.product.name,
          ),
          HorticadeOrderLine(
              heading: 'Deliver to', details: widget.order.location.address),
          HorticadeOrderLine(
            heading: 'Distance',
            details: _distance ??
                Loader(
                    color: Colors.orange,
                    background: HorticadeTheme.scaffoldBackground!),
          ),
          HorticadeOrderLine(
            heading: 'Deliver By',
            details: widget.order.deliverBy == null
                ? 'Not Specified'
                : d(widget.order.deliverBy!),
          ),
          HorticadeOrderLine(
            heading: 'Date Created',
            details: dt(widget.order.created),
          ),
          HorticadeOrderLine(
            heading: 'Quantity',
            details: '${widget.order.qty}',
          ),
          HorticadeOrderLine(
            heading: 'Cost per Unit',
            details: c(widget.order.product.cost),
          ),
          HorticadeOrderLine(
            heading: 'Total',
            details: c(widget.order.qty * widget.order.product.cost),
          ),
        ],
      ),
    );
  }
}
