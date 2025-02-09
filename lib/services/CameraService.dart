//Quản lý việc chụp ảnh từ camera.

//Sử dụng package camera để tương tác với camera thiết bị.

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crop_pdf/models/ImageModel.dart';

class CameraService {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  /// Khởi tạo camera
  Future<void> initializeCamera() async {
    try {
      // Lấy danh sách các camera có sẵn trên thiết bị
      final cameras = await availableCameras();

      // Chọn camera đầu tiên (thường là camera sau)
      final firstCamera = cameras.first;

      // Khởi tạo CameraController
      _cameraController = CameraController(
        firstCamera, // Camera được chọn
        ResolutionPreset.high, // Độ phân giải cao
      );

      // Khởi tạo controller và đợi cho đến khi hoàn thành
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
    } catch (e) {
      debugPrint('Lỗi khi khởi tạo camera: $e');
    }
  }

  /// Chụp ảnh và trả về đối tượng ImageModel
  Future<ImageModel?> takePicture() async {
    try {
      if (!_cameraController.value.isInitialized) {
        debugPrint('Camera chưa được khởi tạo');
        return null;
      }

      await Future.delayed(
          const Duration(milliseconds: 500)); // Đợi camera ổn định

      final image = await _cameraController.takePicture();
      print("Ảnh đã chụp: ${image.path}");
      return ImageModel.fromFile(File(image.path));
    } catch (e) {
      debugPrint('Lỗi khi chụp ảnh: $e');
      return null;
    }
  }

  /// Giải phóng tài nguyên camera
  void dispose() {
    if (_cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
  }

  /// Trả về CameraController để sử dụng trong UI (nếu cần)
  CameraController get cameraController => _cameraController;

  /// Trả về Future để đợi camera khởi tạo (nếu cần)
  Future<void> get initializeControllerFuture => _initializeControllerFuture;
}
