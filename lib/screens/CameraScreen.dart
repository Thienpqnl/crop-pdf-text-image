import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crop_pdf/models/ImageModel.dart';
import 'package:flutter_crop_pdf/screens/ImageEditScreen.dart';
import 'package:flutter_crop_pdf/services/CameraService.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraService _cameraService;
  bool _isCameraReady = false;
  final List<ImageModel> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();
    setState(() {
      _isCameraReady = true;
    });
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _cameraService.initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraService.cameraController);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          if (_capturedImages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _capturedImages.length,
                itemBuilder: (context, index) {
                  final image = _capturedImages[index];
                  return ListTile(
                    leading:
                        Image.file(File(image.path), width: 50, height: 50),
                    title: Text('Ảnh ${index + 1}'),
                    subtitle: Text('Chụp lúc: ${image.createdAt}'),
                    onTap: () {
                      // Chuyển sang màn hình chỉnh sửa ảnh
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageEditScreen(imageModel: image),
                        ),
                      ).then((editedImage) {
                        if (editedImage != null) {
                          setState(() {
                            _capturedImages[index] =
                                editedImage; // Cập nhật ảnh đã chỉnh sửa
                          });
                        }
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageModel = await _cameraService.takePicture();
          if (imageModel != null) {
            setState(() {
              _capturedImages.add(imageModel); // Thêm ảnh vào danh sách
            });
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
