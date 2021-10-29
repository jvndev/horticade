import 'package:firebase/models/product.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/image_loader.dart';
import 'package:firebase/shared/types.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidFunc onTap;

  const ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ImageService _images = ImageService();
  Image? _image;

  @override
  void initState() {
    super.initState();

    _images
        .retrieveImage(
            category: widget.product.category.name,
            imageFilename: widget.product.imageFilename)
        .then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(widget.product.uid!),
      color: HorticadeTheme.cardColor,
      child: ListTile(
        onTap: widget.onTap,
        title: Text(
          widget.product.name,
          style: HorticadeTheme.cardTitleTextStyle,
        ),
        subtitle: Text(
          widget.product.category.name,
          style: HorticadeTheme.cardSubTitleTextStyle,
        ),
        leading: _image ??
            ImageLoader(
              color: Colors.orange,
              background: HorticadeTheme.cardColor!,
            ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              c(widget.product.cost),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              widget.product.qty > 0
                  ? 'Quantity: ${widget.product.qty}'
                  : 'Out of stock',
              style: const TextStyle(
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
    );
  }
}
