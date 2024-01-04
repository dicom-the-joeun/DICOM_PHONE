import 'dart:convert';

import 'package:dicom_phone/util/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  late TextEditingController idController;
  late TextEditingController pwController;
  bool loginStatus = false;

  @override
  void onInit() {
    super.onInit();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  /// Login Check
  Future<bool> checkLogin(String username, String password) async {
    String baseUrl = APiEndPoints.baseurl + APiEndPoints.apiEndPoints.login;
    // String requestUrl = "$baseUrl/?"

    final Uri url = Uri.parse(baseUrl);

    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };

    try {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      loginStatus = true;
      print('로그인 성공');
      print('응답 데이터: ${response.body}');
    } else {
      // 로그인 실패
      loginStatus = false;
      print('로그인 실패');
      print('응답 코드: ${response.statusCode}');
      print('응답 데이터: ${response.body}');
    }
  } catch (error) {
    // 에러 처리
    print('오류 발생: $error');
  }
    return loginStatus;
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End
