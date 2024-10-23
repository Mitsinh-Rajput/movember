import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:movember/views/base/custom_image.dart';

class CameraScreen extends StatefulWidget {
  final String? assets;
  const CameraScreen({super.key, this.assets});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  File? _imageFile;
  bool _isCameraInitialized = false;
  List<CameraDescription>? cameras;
  int _cameraId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeCamera(_cameraId);
    });
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![cameraIndex], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _switchCamera() async {
    if (cameras!.length > 1) {
      _cameraId = _cameraId == 0 ? 1 : 0;
      await _initializeCamera(_cameraId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> _takePicture() async {
    setState(() {
      isLoading = true;
    });
    if (!_controller.value.isInitialized) {
      return;
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      XFile picture = await _controller.takePicture();
      File imageFile = File(picture.path);

      // Load the captured image
      img.Image capturedImage = img.decodeImage(imageFile.readAsBytesSync())!;

      // Load the asset image
      ByteData data = await rootBundle.load(widget.assets!);
      Uint8List bytes = data.buffer.asUint8List();
      img.Image overlayImage = img.decodeImage(bytes)!;

      // Resize the asset image if needed (optional)
      img.Image resizedOverlay = img.copyResize(
        overlayImage,
        width: 300,
      );
      img.compositeImage(capturedImage, resizedOverlay, center: true, blend: img.BlendMode.multiply);

      File newImageFile = File(picture.path)..writeAsBytesSync(img.encodePng(capturedImage));

      setState(() {
        _imageFile = newImageFile;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Container(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _imageFile == null
                      ? Stack(
                          children: [
                            Center(child: Container(height: size.height - 100, width: size.width - 200, child: CameraPreview(_controller))),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: CustomImage(
                                path: widget.assets ?? "",
                                width: 300,
                              ),
                            ),
                            if (isLoading)
                              const Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))),
                          ],
                        )
                      : Image.file(
                          _imageFile!,
                          height: size.height - 50,
                          width: size.width,
                        ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        if (_imageFile == null) ...[
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _switchCamera();
                              },
                              child: Icon(
                                Icons.cameraswitch_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                        ],
                        if (_imageFile != null) Spacer(),
                        _imageFile != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            : const SizedBox(),
                        const Spacer(flex: 3),
                        _imageFile == null
                            ? GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey, borderRadius: const BorderRadius.all(Radius.circular(100)), border: Border.all(color: Colors.white, width: 2)),
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(flex: 3),
                        _imageFile != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, _imageFile);
                                },
                              )
                            : const SizedBox(),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
