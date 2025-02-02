//Hiển thị giao diện chụp ảnh và xem trước ảnh.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crop_pdf/services/CameraService.dart'; // Import class CameraService

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraService _cameraService;
  bool _isCameraReady = false;

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
      body: FutureBuilder<void>(
        future: _cameraService.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraService.cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageFile = await _cameraService.takePicture();
          if (imageFile != null) {
            // Xử lý file ảnh đã chụp (ví dụ: hiển thị hoặc lưu trữ)
            print('Ảnh đã chụp: ${imageFile.path}');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
