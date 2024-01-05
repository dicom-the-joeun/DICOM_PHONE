import 'package:dicom_phone/VM/remote_datasource.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late TextEditingController idController;
  late TextEditingController pwController;
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  bool loginStatus = false;

  @override
  void onInit() {
    super.onInit();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  Future<String> getAccessToken() async {
    const String url = "auth/refresh";
    final String token = await getRefreshToken();
    final Map<String, dynamic> tokenheaders = {'refresh-token': token};

    final response = await datasource.get(url, headers: tokenheaders);
    if (response != null) {
      Logger().d(response);
      dio.Response<dynamic> resData = response;
      Map<String, dynamic> mapData = resData.headers.map;
      String accesstoken = mapData['access_token'].first;
      await _setAccessToken(accesstoken);
      return accesstoken;
    }
    throw Exception('Failed to get access token');
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
        if (await _setAccessToken(accesstoken!) &&
            await _setRefreshToken(refreshtoken!)) {
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

  /// RefreshToken 가져오기
  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hasSeenOnboarding = prefs.getString('refreshtoken') ?? '';
    return hasSeenOnboarding;
  }

  /// RefreshToken 저장하기
  Future<bool> _setRefreshToken(String refreshtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetrefreshToken =
        prefs.setString('refreshtoken', refreshtoken);
    return didsetrefreshToken;
  }

  /// AccessToken 저장하기
  Future<bool> _setAccessToken(String accesstoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetaccessToken =
        prefs.setString('accesstoken', accesstoken);
    return didsetaccessToken;
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End








