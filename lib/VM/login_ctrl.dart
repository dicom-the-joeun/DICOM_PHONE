import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logger/logger.dart';

class LoginController extends GetxController {
  late TextEditingController idController;
  late TextEditingController pwController;
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  final TokenHandler _tokenHandler = TokenHandler();
  bool loginStatus = false;

  @override
  void onInit() {
    super.onInit();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  /// Login Check
  Future<bool> checkLogin(String username, String password) async {
    
    bool loginStatus = false;

    const String url = "auth/login";
    String data =
        'username=${username.trim()}&password=${password.trim()}&grant_type=&scope=&client_id=&client_secret=';
    final Map<String, dynamic> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    };

    try {
      final dio.Response<dynamic> response =
          await datasource.post(url, data, headers: headers);
      if (response.statusCode == 200) {
        String? accesstoken = response.headers['access_token']?.first;
        String? refreshtoken = response.headers['refresh_token']?.first;
        if (await _tokenHandler.setAccessToken(accesstoken!) &&
            await _tokenHandler.setRefreshToken(refreshtoken!)) {
          loginStatus = true;
        }
      } else {
        loginStatus = false;
      }
    } catch (e) {
      loginStatus = false;
    }
    return loginStatus;
  }

  /// logout 하기
  logoutUser(){
    _tokenHandler.deleteToken();
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End








