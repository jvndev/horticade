import 'package:firebase/models/order.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/image_loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  dynamic onPressed;

  OrderCard({Key? key, required this.order, this.onPressed}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final ImageService _images = ImageService();
  Image? _image;

  @override
  void initState() {
    super.initState();

    _images
        .retrieveImage(
            category: widget.order.product.category.name,
            imageFilename: widget.order.product.imageFilename)
        .then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String createdDate = dt(widget.order.created);

    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        color: HorticadeTheme.cardColor,
        child: ListTile(
          title: Text(
            widget.order.product.name,
            style: HorticadeTheme.cardTitleTextStyle,
          ),
          leading: _image ??
              ImageLoader(
                color: Colors.orange,
                background: HorticadeTheme.cardColor!,
              ),
          trailing: Text('${widget.order.qty.toString()}'
              ' ordered for R${widget.order.product.cost}'),
          subtitle: Text(
            createdDate,
            style: HorticadeTheme.cardSubTitleTextStyle,
          ),
        ),
      ),
    );
  }
}
