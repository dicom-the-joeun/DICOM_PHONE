import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/VM/theme_ctrl.dart';
import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final ThemeController themeController = Get.put(ThemeController());
  final LoginController loginController = Get.put(LoginController());

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting(); // TableCalendar 언어 설정
  final thmeInfo = await themeController.getThemeInfo();
  final autoLoginStatus = await loginController.getSaveIdText();
  runApp(MyApp(thmeInfo, autoLoginStatus));
}

class MyApp extends StatefulWidget {
  final bool thmeInfo;
  final bool autoLoginStatus;
  const MyApp(this.thmeInfo, this.autoLoginStatus, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode _themeMode = ThemeMode.system; // 시스템 설정 기본 세팅 모드
  
  late ThemeMode _themeMode;

  @override
  void initState() {
    _themeMode = widget.thmeInfo ? ThemeMode.dark : ThemeMode.light;
    super.initState();
  }

  _changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    setState(() {});
  }

  static const seedColor = Colors.deepPurple;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DICOM_PHONE',
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

      // home: LoginPage(onChangeTheme: _changeThemeMode),
      home: widget.autoLoginStatus == true
          ? HomePage(onChangeTheme: _changeThemeMode)
          : LoginPage(onChangeTheme: _changeThemeMode),

      debugShowCheckedModeBanner: false,
    );
  }
}
