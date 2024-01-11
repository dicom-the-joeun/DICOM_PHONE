import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/VM/theme_ctrl.dart';
import 'package:dicom_phone/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final ThemeController themeController = Get.put(ThemeController());

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting(); // TableCalendar 언어 설정
  final thmeInfo = await themeController.getThemeInfo();
  runApp(MyApp(thmeInfo));
}

class MyApp extends StatefulWidget {
  final bool thmeInfo;
  const MyApp(this.thmeInfo, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode _themeMode = ThemeMode.system; // 시스템 설정 기본 세팅 모드
  late ThemeMode _themeMode; // 시스템 설정 기본 세팅 모드

  @override
  void initState() {
    _themeMode = widget.thmeInfo ? ThemeMode.dark : ThemeMode.light;
    // if (widget.thmeInfo == false) {
    //   _themeMode = ThemeMode.light;
    // } else {
    //   _themeMode = ThemeMode.dark;
    // }
    super.initState();
  }

  _changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    setState(() {});
  }

  static const seedColor = Colors.deepPurple;
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
