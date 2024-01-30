import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/VM/theme_ctrl.dart';
import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/View/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Function(ThemeMode) onChangeTheme;
  final bool backStatus;

  /// Appbar이고 backStatus인자로 true를 넣으면 뒤로가기 생기고 false넣으면 뒤로가기 안생김
  const MyAppbar(
      {super.key, required this.onChangeTheme, required this.backStatus});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final Thumbnail thumbnail = Get.put(Thumbnail());

    // ignore: deprecated_member_use
    return AppBar(
      title: GestureDetector(
        onTap: () {
          thumbnail.collectionValue.value = 1;
          Get.offAll(() => HomePage(onChangeTheme: onChangeTheme),
              transition: Transition.noTransition);
        },
        child: SizedBox(
          child: Image.asset(
            width: 60,
            height: 60,
            "images/pacs.png",
          ),
        ),
      ),
      automaticallyImplyLeading: backStatus, // 뒤로가기 없애기 (false넣어줘야함)
      centerTitle: true,
      actions: [
        Obx(
          () => Column(
            children: [
              TextButton(
                onPressed: () {
                  themeController.themeStatus.value =
                      !themeController.themeStatus.value;
                  changeMode(
                      themeController.themeStatus.value, themeController);
                },
                child: Column(
                  children: [
                    Icon(
                      themeController.themeStatus.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      size: 20,
                    ),
                    Text(themeController.themeStatus.value ? "다크모드" : "라이트모드"),
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            showLogoutDialog(context);
          },
          child: const Column(
            children: [
              Icon(
                Icons.person_off,
                size: 20,
              ),
              Text("로그아웃"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // preferredSize 지정
  Size get preferredSize => const Size.fromHeight(60);

  // --- Functions ---

  /// 로그아웃 버튼 누르면 나오는 다이얼로그
  /// CupertinoAlertDialog는 context타입이 존재해야해서 이런식으로 해야함
  void showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // 다른곳 클릭시 닫기
      builder: (BuildContext context) {
        return logoutDialog();
      },
    );
  }

  CupertinoAlertDialog logoutDialog() {
    return CupertinoAlertDialog(
      title: const Text("정말 로그아웃 하시겠습니까?"),
      actions: [
        CupertinoDialogAction(
          child: Column(
            children: [
              CupertinoButton(
                minSize: 50,
                child: const Text("확인"),
                onPressed: () async {
                  await logoutUser();
                  Get.offAll(
                    () => LoginPage(onChangeTheme: onChangeTheme),
                    transition: Transition.noTransition,
                  );
                },
              ),
              CupertinoButton(
                child: const Text(
                  "취소",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 로그아웃시 토큰 없애기
  logoutUser() async {
    final loginController = Get.find<LoginController>();
    loginController.pwController.text = "";
    await loginController.logoutUser();
  }

  /// 테마모드 바꾸는 함수
  changeMode(bool status, ThemeController themeController) {
    if (status == false) {
      onChangeTheme(ThemeMode.light);
      themeController.saveThemeInfo();
    } else {
      onChangeTheme(ThemeMode.dark);
      themeController.saveThemeInfo();
    }
  }
} // End
