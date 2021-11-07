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
  List<CameraDescription> cameras = [];
  List<Widget> cameraActions = []; // front & back facing options
  CameraController? camera;
  CameraPreview? cameraPreview;
  String error = '';

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      this.cameras = cameras;

      if (this.cameras.isNotEmpty) {
        setState(() {
          cameraActions = cameras
              .map((cameraDesc) => IconButton(
                  icon: Icon(
                      cameraDesc.lensDirection == CameraLensDirection.front
                          ? Icons.camera_front
                          : Icons.photo_camera_back),
                  onPressed: () {
                    setCamera(cameraDesc);
                  }))
              .toList();
          defaultCamera();
        });
      } else {
        setState(() {
          error = 'No Cameras detected';
        });
      }
    });
  }

  Future<void> setCamera(CameraDescription? cameraDesc) async {
    if (cameraDesc != null) {
      camera = CameraController(
        cameraDesc,
        cameraResolution,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: false,
      );

      try {
        await camera!.initialize().timeout(awaitTimeout);
        // TODO //
        await camera!.setFlashMode(FlashMode.off);
        setState(() {
          cameraPreview = CameraPreview(camera!);
        });
      } on CameraException {
        camera = null;
        setState(() {
          error = 'Failed to initialize camera';
        });
      }
    } else {
      camera = null;
      setState(() {
        error = 'Failed to initialize camera';
      });
    }
  }

  // Start with backfacing camera if the phone has it.
  void defaultCamera() {
    if (cameras.length == 1) {
      setCamera(cameras.first);
    } else if (cameras.length > 1) {
      CameraDescription? backCameraDesc = cameras
          .firstWhere((desc) => desc.lensDirection == CameraLensDirection.back);

      setCamera(backCameraDesc);
    } else {
      camera = null;
    }
  }

  Widget loader() {
    return error.isNotEmpty
        ? Text(error)
        : const Loader(
            color: Colors.orange,
            background: Colors.black,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HorticadeAppBar(
        title: 'Product Picture',
        actions: cameraActions,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: camera == null ? loader() : cameraPreview,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[700],
        onPressed: () async {
          XFile pic;

          try {
            pic = await camera!.takePicture();
          } on CameraException {
            // Capture button probably tapped multiple times
            return;
          }
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
    );
  }
}
