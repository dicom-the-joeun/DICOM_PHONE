import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class TokenHandler {
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();

  /// AccessToken 가져오기
  Future<String> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      return pref.getString('access_token')!;
    } catch (e) {
      print(e);
      return '';
    } finally {
      // print('세이브토큰:  ${pref.getString('access_token')}');
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
    final Map<String, dynamic> tokenheaders = {
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await datasource.get(url, headers: tokenheaders);
      if (response != null) {
        // Logger().d(response);
        dio.Response<dynamic> resData = response;
        if (resData.statusCode == 200) {
          Map<String, dynamic> mapData = resData.headers.map;
          String accesstoken = mapData['access_token'].first;
          print("저장할 토큰: $accesstoken");
          await setAccessToken(accessToken: accesstoken);
        }
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

  Future<String> fetchData() async {
    await TokenHandler().saveAccessToken();
    return await TokenHandler().getAccessToken();
  }
}
