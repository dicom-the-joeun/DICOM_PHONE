import 'package:dicom_phone/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  /// 앱 초기화 및 바인딩
  WidgetsFlutterBinding.ensureInitialized();
  /// 화면 가로로 고정
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // 바탕화면 검은색으로 고정
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // 검은색으로 고정
          titleTextStyle: TextStyle(
          color: Colors.red, //  빨간색으로 고정
          fontSize: 30 // 글씨 크기 
          ),
        ),
        
        useMaterial3: true,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}