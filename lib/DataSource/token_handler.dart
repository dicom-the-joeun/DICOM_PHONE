import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

// class TokenHandler extends GetxService {
class TokenHandler {
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  final String? baseUrl = dotenv.env['baseurl'];
  String token = "";

  Future<void> init() async {
    token = await TokenHandler().fetchData();
    // print("갱신된 token: $token");
  }

  /// AccessToken 가져오기
  Future<String> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      return pref.getString('access_token')!;
    } catch (e) {
      print(e);
      return '';
    } finally {
    }
  }

  /// AccessToken 기기에 저장
  setAccessToken({
    required String accessToken,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      pref.setString('access_token', accessToken);
    } catch (e) {
      print(e);
    }
  }

  /// AccsessToken 요청해서 저장하기
  saveAccessToken() async {
    const String url = "auth/refresh";
    final String token = await getRefreshToken();

    try {
      final response = await http.get(Uri.parse('$baseUrl$url'),
          headers: {'Authorization': 'Bearer $token'});
      // Logger().d(response);
      if (response.statusCode == 200) {
        String accessToken = response.headers['access_token']!;
        
        await setAccessToken(accessToken: accessToken);
        print("저장할 토큰: $accessToken");
      } else {
        await setAccessToken(accessToken: '');
        print("토큰 재발급 실패");
      }
        } catch (e) {
      print('error $e');
      throw Exception('Failed to get access token');
    }
  }

  /// RefreshToken 가져오기
  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hasSeenOnboarding = prefs.getString('refresh_token') ?? '';
    return hasSeenOnboarding;
  }

  /// RefreshToken 저장하기
  Future<bool> setRefreshToken(String refreshtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetrefreshToken =
        prefs.setString('refresh_token', refreshtoken);
    return didsetrefreshToken;
  }

  /// logout tokem 삭제
  deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  /// 토큰 발급하기
  fetchData() async {
    debugPrint('토큰 패치됨');
    await TokenHandler().saveAccessToken();
    return await TokenHandler().getAccessToken();
  }
}
