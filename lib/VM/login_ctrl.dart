import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late TextEditingController idController;
  late TextEditingController pwController;
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  final TokenHandler _tokenHandler = TokenHandler();
  RxBool idSaveStatus = false.obs;
  RxBool autoLoginStatus = false.obs;
  bool loginStatus = false;

  @override
  onInit() async {
    idController = TextEditingController();
    pwController = TextEditingController();
    await getIdText();
    await getSaveIdText();
    super.onInit();
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
  logoutUser() {
    _tokenHandler.deleteToken();
  }

  /// id 기억하기, 자동로그인 체크박스 status값 저장
  setSaveIdText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveIdTextStatus', idSaveStatus.value);
    prefs.setBool('saveAutoLoginStatus', autoLoginStatus.value);
  }
  
  /// id 기억하기, 자동로그인 체크박스 status값 불러오기
  getSaveIdText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idSaveStatus.value = prefs.getBool('saveIdTextStatus') ?? false;
    autoLoginStatus.value = prefs.getBool('saveAutoLoginStatus') ?? false;

    print("autoLoginStatus: ${autoLoginStatus.value}");
    // 앱 시작할때 자동로그인 적용하기위해 autoLoginStatus를 리턴
    return autoLoginStatus.value;
  }

  /// id textfeild에 저장하기
  Future<bool> setIdText(String idText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> saveIdText = prefs.setString('idText', idText);
    print("idText: $idText");
    return saveIdText;
  }

  /// id text 가져오기
  getIdText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idController.text = prefs.getString('idText') ?? " ";
  }

  /// id text 지우기
  deleteIdText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('idText');
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End








