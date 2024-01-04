import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(
                "assets/images/pacs.png",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            loginText(
              content: "ID",
              textController: loginController.idController,
            ),
            loginText(
              content: "Password",
              textController: loginController.pwController,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoButton.filled(
                onPressed: () {
                  // 로그인 시도 성공 여부 따지기
                  // errorToast(
                  //     context: context, content: "ID나 Password를 다시 확인하세요");
                },
                child: const Text("로그인"),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- Functions ---

  /// 로그인 텍스트 위젯
  loginText(
      {required String content,
      required TextEditingController textController}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 400,
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: content,
          ),
        ),
      ),
    );
  }

  /// 로그인 실패 Toast
  // errorToast({required BuildContext context, required String content}) {
  //   Fluttertoast.showToast(
  //     msg: content,
  //     gravity: ToastGravity.TOP,
  //     backgroundColor: Theme.of(context).colorScheme.error,
  //     textColor: Theme.of(context).colorScheme.onError,
  //     fontSize: 20,
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  // }
} // End
