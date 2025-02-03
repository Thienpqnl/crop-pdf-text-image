//Đại diện cho một ảnh, bao gồm đường dẫn, kích thước, và các thông tin khác.

import 'dart:io';

class ImageModel {
  final String id; // ID duy nhất cho mỗi ảnh
  final String path; // Đường dẫn đến file ảnh
  final DateTime createdAt; // Thời gian tạo

  ImageModel({
    required this.id,
    required this.path,
    required this.createdAt,
  });

  // Factory method để tạo ImageModel từ file ảnh
  factory ImageModel.fromFile(File file) {
    return ImageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Tạo ID duy nhất
      path: file.path,
      createdAt: DateTime.now(),
    );
  }
}
