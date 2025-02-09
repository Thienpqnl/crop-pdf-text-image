import 'package:flutter/material.dart';
import 'package:flutter_crop_pdf/screens/CameraScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn banner debug
      title: 'Book Scanner App', // Tiêu đề ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu chủ đạo
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CameraScreen(), // Màn hình khởi động là CameraScreen
    );
  }
}
