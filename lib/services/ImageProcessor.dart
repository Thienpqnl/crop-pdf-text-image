//Xử lý ảnh sau khi chụp hoặc chọn từ thư viện.

//Các phương thức: cắt xén ảnh, chỉnh sửa độ sáng/tương phản, phát hiện biên (sử dụng OpenCV hoặc thư viện tương tự).

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';

class ImageProcessor {
  /// Cắt xén ảnh
  Future<Uint8List?> cropImage({
    required Uint8List imageBytes,
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      // Decode ảnh từ Uint8List
      final image = decodeImage(imageBytes);
      if (image == null) throw Exception('Không thể decode ảnh.');

      // Cắt xén ảnh
      final croppedImage = copyCrop(
        image,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Encode ảnh thành Uint8List
      return encodePng(croppedImage);
    } catch (e) {
      print('Lỗi khi cắt xén ảnh: $e');
      return null;
    }
  }

  /// Chỉnh sửa độ sáng
  Future<Uint8List?> adjustBrightness({
    required Uint8List imageBytes,
    required int brightness, // Giá trị từ -255 đến 255
  }) async {
    try {
      final image = decodeImage(imageBytes);
      if (image == null) throw Exception('Không thể decode ảnh.');

      // Chỉnh sửa độ sáng
      final adjustedImage = copyResize(image); // Sao chép và resize (nếu cần)
      adjustColor(adjustedImage, brightness: brightness);

      return encodePng(adjustedImage);
    } catch (e) {
      print('Lỗi khi chỉnh sửa độ sáng: $e');
      return null;
    }
  }

  /// Chỉnh sửa độ tương phản
  Future<Uint8List?> adjustContrast({
    required Uint8List imageBytes,
    required double contrast, // Giá trị từ -100 đến 100
  }) async {
    try {
      final image = decodeImage(imageBytes);
      if (image == null) throw Exception('Không thể decode ảnh.');

      // Chỉnh sửa độ tương phản
      final adjustedImage = copyResize(image); // Sao chép và resize (nếu cần)
      adjustColor(adjustedImage, contrast: contrast);

      return encodePng(adjustedImage);
    } catch (e) {
      print('Lỗi khi chỉnh sửa độ tương phản: $e');
      return null;
    }
  }

  /// Chuyển đổi File thành Uint8List
  Future<Uint8List> fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  /// Chuyển đổi Uint8List thành File
  Future<File> uint8ListToFile(Uint8List bytes, String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }
}
