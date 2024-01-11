import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool themeStatus = false.obs;
  // bool selectedMode = false;
  @override
  void onInit() async {
    await getThemeInfo();
    super.onInit();
  }


  /// SharedPreferences - 테마 변경 저장된 값 있으면 가져오기 (없으면 기본값)
  getThemeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    themeStatus.value = prefs.getBool('ThemeMode') ?? false;
    return themeStatus.value;
  }

  saveThemeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ThemeMode", themeStatus.value);       
  }

}