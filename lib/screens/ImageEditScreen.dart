//Hiển thị file PDF đã tạo và cho phép chia sẻ hoặc lưu file.

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_crop_pdf/models/ImageModel.dart';
import 'package:flutter_crop_pdf/services/ImageProcessor.dart';

class ImageEditScreen extends StatefulWidget {
  final ImageModel imageModel; // Ảnh cần chỉnh sửa

  const ImageEditScreen({Key? key, required this.imageModel}) : super(key: key);

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late ImageProcessor _imageProcessor;
  late File _imageFile; // File ảnh hiện tại
  double _brightness = 0; // Giá trị độ sáng
  double _contrast = 0; // Giá trị độ tương phản

  @override
  void initState() {
    super.initState();
    _imageProcessor = ImageProcessor();
    _imageFile =
        File(widget.imageModel.path); // Khởi tạo file ảnh từ ImageModel
  }

  /// Cập nhật ảnh với độ sáng và độ tương phản mới
  Future<void> _updateImage() async {
    final imageBytes = await _imageProcessor.fileToUint8List(_imageFile);

    // Chỉnh sửa độ sáng
    final brightenedImage = await _imageProcessor.adjustBrightness(
      imageBytes: imageBytes,
      brightness: _brightness.toInt(),
    );

    // Chỉnh sửa độ tương phản
    final contrastedImage = await _imageProcessor.adjustContrast(
      imageBytes: brightenedImage ?? imageBytes,
      contrast: _contrast,
    );

    if (contrastedImage != null) {
      setState(() {
        _imageFile = File(widget.imageModel.path);
      });
    }
  }

  /// Lưu ảnh đã chỉnh sửa
  Future<void> _saveImage() async {
    final newPath =
        '${_imageFile.parent.path}/edited_${_imageFile.uri.pathSegments.last}';
    final newFile = await _imageFile.copy(newPath);
    // Trả về ảnh đã chỉnh sửa (có thể sử dụng Navigator.pop để trả về kết quả)
    Navigator.pop(context, ImageModel.fromFile(newFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa ảnh'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(_imageFile, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Độ sáng: ${_brightness.toInt()}'),
                Slider(
                  value: _brightness,
                  min: -255,
                  max: 255,
                  onChanged: (value) {
                    setState(() {
                      _brightness = value;
                    });
                    _updateImage();
                  },
                ),
                Text('Độ tương phản: ${_contrast.toStringAsFixed(2)}'),
                Slider(
                  value: _contrast,
                  min: -100,
                  max: 100,
                  onChanged: (value) {
                    setState(() {
                      _contrast = value;
                    });
                    _updateImage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
