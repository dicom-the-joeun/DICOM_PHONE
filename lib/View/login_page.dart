import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/View/series_listview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const LoginPage({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset(
                  "images/pacs.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              loginText(
                content: "ID",
                textController: loginController.idController,
                visiableStatus: false,
              ),
              loginText(
                content: "Password",
                textController: loginController.pwController,
                visiableStatus: true,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ID 기억하기"),
                      Obx(
                        () => Checkbox(
                          value: loginController.idSaveStatus.value,
                          onChanged: (value) {
                            loginController.idSaveStatus.value = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CupertinoButton.filled(
                      onPressed: () async {
                        // 로그인 시도 성공 여부 따지기
                        if (loginController.idController.text.isNotEmpty &&
                            loginController.pwController.text.isNotEmpty) {
                          if (await loginController.checkLogin(
                              loginController.idController.text,
                              loginController.pwController.text)) {
                            // 체크박스에따라서 아이디 저장할지말지 정하기
                            loginController.setSaveIdText();
                            loginController.idSaveStatus.value == true
                                ? loginController.setIdText(
                                    loginController.idController.text)
                                : loginController.deleteIdText();
                            Get.to(() => const HomePage());
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnacbar(
                              context: context,
                              title: "실패",
                              content: "ID나 Password를 다시 확인하세요",
                              resultBackColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.error,
                              resultTextColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.onError,
                            );
                          }
                          // 로고 사진 변경, 자동로그인, 체크박스 처리@@@@@@@@@@@@@
                        } else {
                          showSnacbar(
                            context: context,
                            title: "실패",
                            content: "ID와 Password를 입력해주세요",
                            resultBackColor:
                                // ignore: use_build_context_synchronously
                                Theme.of(context).colorScheme.error,
                            resultTextColor:
                                // ignore: use_build_context_synchronously
                                Theme.of(context).colorScheme.onError,
                          );
                        }
                      },
                      child: const Text("로그인"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SireisListviewPage());
                    },
                    child: const Text("SireisPage(ListViewPage) 이동"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const HomePage());
                    },
                    child: const Text("홈페이지 이동"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  /// 로그인 성공여부 스낵바
  showSnacbar(
      {required BuildContext context,
      required String title,
      required String content,
      required Color resultBackColor,
      required Color resultTextColor}) {
    Get.snackbar(
      title,
      content,
      backgroundColor: resultBackColor,
      colorText: resultTextColor,
      // duration: const Duration(microseconds: 1000),
      animationDuration: const Duration(microseconds: 1000),
    );
  }

  /// 로그인 텍스트 위젯
  loginText({
    required String content,
    required TextEditingController textController,
    required bool visiableStatus,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 400,
        child: TextField(
          controller: textController,
          obscureText: visiableStatus,
          decoration: InputDecoration(
            labelText: content,
          ),
        ),
      ),
    );
  }
} // End
