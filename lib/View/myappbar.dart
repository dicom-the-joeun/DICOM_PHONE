import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/VM/theme_ctrl.dart';
import 'package:dicom_phone/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Function(ThemeMode) onChangeTheme;
  const MyAppbar({super.key, required this.onChangeTheme,});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return AppBar(
      title: SizedBox(
        width: 45,
        height: 45,
        child: Image.asset("images/pacs.png"),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => Column(
            children: [
              TextButton(
                onPressed: () {
                  themeController.themeStatus.value = !themeController.themeStatus.value;
                  changeMode(themeController.themeStatus.value);
                },
                child: Column(
                  children: [
                    Icon(themeController.themeStatus.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                        size: 20,
                        ),
                    Text(themeController.themeStatus.value ? "라이트모드" : "다크모드"),
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
  logoutUser() {
    TokenHandler tokenHandler = TokenHandler();
    tokenHandler.deleteToken();
  }

  changeMode(bool status){
    status
    ? onChangeTheme(ThemeMode.light)
    : onChangeTheme(ThemeMode.dark);
  }

} // End
