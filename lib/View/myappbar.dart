import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/VM/theme_ctrl.dart';
import 'package:dicom_phone/View/login_page.dart';
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

    // ignore: deprecated_member_use
    return AppBar(
      title: SizedBox(
        width: 45,
        height: 45,
        child: Image.asset("images/pacs.png"),
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
                  changeMode(themeController.themeStatus.value, themeController);
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
            logoutUser();
            Get.offAll(LoginPage(onChangeTheme: onChangeTheme));
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

  /// 로그아웃시 토큰 없애기
  logoutUser() {
    TokenHandler tokenHandler = TokenHandler();
    tokenHandler.deleteToken();
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
