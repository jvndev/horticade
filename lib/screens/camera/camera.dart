import 'package:camera/camera.dart';
import 'package:horticade/screens/camera/show_picture.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  Future<CameraController?> _getCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    CameraController? controller = cameras.isEmpty
        ? null
        : CameraController(
            cameras.first,
            cameraResolution,
            imageFormatGroup: ImageFormatGroup.jpeg,
            enableAudio: false,
          );

    try {
      await controller?.initialize().timeout(awaitTimeout);
    } on CameraException {
      return null;
    }

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraController?>(
      future: _getCameraController(),
      builder: (context, snapshot) =>
          snapshot.connectionState != ConnectionState.done
              ? Loader(
                  color: Colors.orange,
                  background: HorticadeTheme.scaffoldBackground!,
                )
              : Scaffold(
                  appBar: HorticadeAppBar(title: 'Product Picture'),
                  backgroundColor: HorticadeTheme.scaffoldBackground,
                  body: snapshot.data == null
                      ? const Text('Camera could not be accessed')
                      : CameraPreview(snapshot.data as CameraController),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.grey[700],
                    onPressed: () async {
                      XFile pic = await snapshot.data!.takePicture();

                      bool accepted = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowPicture(path: pic.path),
                        ),
                      );

                      if (accepted) {
                        Navigator.of(context).pop(pic.path);
                      }
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.orange,
                    ),
                  ),
                ),
    );
  }
}
