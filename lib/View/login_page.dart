import 'package:dicom_phone/VM/login_ctrl.dart';
import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/View/series_listview_page.dart';
import 'package:dicom_phone/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const LoginPage({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("자동로그인"),
                      Obx(
                        () => Checkbox(
                          value: loginController.autoLoginStatus.value,
                          onChanged: (value) {
                            loginController.autoLoginStatus.value = value!;
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
                              loginController.pwController.text) == true) {
                            // 체크박스에따라서 아이디 저장할지말지 정하기
                            print(11111);
                            loginController.setSaveIdText();
                            loginController.idSaveStatus.value == true
                                ? loginController.setIdText(
                                    loginController.idController.text)
                                : loginController.deleteIdText();
                            Get.to(
                              () => HomePage(
                                onChangeTheme: onChangeTheme,
                              ),
                              transition: Transition.noTransition,
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnacbar(
                              context: context,
                              title: "실패",
                              message: "ID나 Password를 다시 확인하세요",
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
                            message: "ID와 Password를 입력해주세요",
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
                      Get.to(() => SireisListviewPage(
                            onChangeTheme: onChangeTheme,
                          ));
                    },
                    child: const Text("SireisPage(ListViewPage) 이동"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => HomePage(
                            onChangeTheme: onChangeTheme,
                          ));
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
      required String message,
      required Color resultBackColor,
      required Color resultTextColor}) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: resultTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: resultTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: resultBackColor,
        duration: const Duration(milliseconds: 1000),
        snackPosition: SnackPosition.TOP,
        borderRadius: 50, // 둥글게하기
        margin: const EdgeInsets.fromLTRB(60, 10, 60, 10), // 마진값으로 사이즈 조절
        // animationDuration: const Duration(microseconds: 1000),
      ),
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
