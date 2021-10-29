import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDisplay extends StatelessWidget {
  final Image image;
  const ImageDisplay({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PhotoView(
            minScale: PhotoViewComputedScale.contained * 1.0,
            imageProvider: image.image,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            color: Colors.greenAccent,
            iconSize: 70.00,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.check),
          ),
        ),
      ]),
    );
  }
}
