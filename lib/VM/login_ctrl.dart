import 'dart:convert';
import 'dart:io';

import 'package:dicom_phone/util/api_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    bool loginStatus = false; // 이 부분 추가

    // String baseUrl = dotenv.env['baseurl']! + APiEndPoints.apiEndPoints.login;

    


//     final Uri url = Uri.parse(baseUrl);

// // 로그인에 사용될 데이터
//     Map<String, dynamic> data = {
//       'username': username,
//       'password': password,
//     };
//     try {
//       final http.Response response = await http.post(
//         url,
//         headers: {
//           'accept': 'application/json',
//           'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//         },
//         body: data,
//       );

//       if (response.statusCode == 200) {
//         // 로그인 성공
//         loginStatus = true;
//         String responseBody = utf8.decode(response.bodyBytes);
//         Map<String,dynamic> dataConvertedJSON = jsonDecode(responseBody);
//         Map<String,String> dataConvertedJSONHeaders = response.headers;
//         print('로그인 성공');
//         print('응답 데이터: ${dataConvertedJSON['result']}');
//         print('Access Token: ${dataConvertedJSONHeaders['access_token']}');
//       } else {
//         // 로그인 실패
//         loginStatus = false;
//         print('로그인 실패');
//         // print('응답 코드: ${response.statusCode}');
//         // print('응답 데이터: ${response.body}');
//       }
//     } catch (error) {
//       // 에러 처리
//       print('오류 발생: $error');
//     }

    return loginStatus;
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End
