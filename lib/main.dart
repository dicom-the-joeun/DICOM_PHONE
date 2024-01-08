import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting(); // TableCalendar 언어 설정
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // 기본 세팅 모드

  _changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    setState(() {});
  }

  static const seedColor = Color.fromARGB(255, 234, 248, 248);
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return GetMaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.black, // 바탕화면 검은색으로 고정
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.black, // 검은색으로 고정
      //     titleTextStyle: TextStyle(
      //         color: Colors.red, //  빨간색으로 고정
      //         fontSize: 30 // 글씨 크기
      //         ),
      //   ),

      //   useMaterial3: true,
      // ),
      title: 'Flutter Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: seedColor,
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.red, //  빨간색으로 고정
              fontSize: 30 // 글씨 크기
              ),
        ),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: seedColor,
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.red, //  빨간색으로 고정
              fontSize: 30 // 글씨 크기
              ),
        ),
      ),

      // home: const Home(),
      home: LoginPage(onChangeTheme: _changeThemeMode),
      // home: loginController.getAccessToken() == null
      // ? LoginPage(onChangeTheme: _changeThemeMode)
      // : loginController.getRefreshToken() == null
      // ? LoginPage(onChangeTheme: _changeThemeMode)
      // : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
