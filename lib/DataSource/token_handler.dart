import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class TokenHandler {
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();

  /// AccessToken 가져오기
  Future<String> getAccessToken() async {
    const String url = "auth/refresh";
    final String token = await getRefreshToken();
    // final Map<String, dynamic> tokenheaders = {'refresh-token': token};
    final Map<String, dynamic> tokenheaders = {'Authorization': 'Bearer $token'};

    final response = await datasource.get(url, headers: tokenheaders);
    if (response != null) {
      Logger().d(response);
      dio.Response<dynamic> resData = response;
      Map<String, dynamic> mapData = resData.headers.map;
      print("mapData: $mapData");
      String accesstoken = mapData['access_token'].first;
      await setAccessToken(accesstoken);
      return accesstoken;
    }
    throw Exception('Failed to get access token');
  }

  /// RefreshToken 가져오기
  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hasSeenOnboarding = prefs.getString('refreshtoken') ?? '';
    return hasSeenOnboarding;
  }

  /// RefreshToken 저장하기
  Future<bool> setRefreshToken(String refreshtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetrefreshToken =
        prefs.setString('refreshtoken', refreshtoken);
        print("refreshtoken: $refreshtoken");
    return didsetrefreshToken;
  }

  /// AccessToken 저장하기
  Future<bool> setAccessToken(String accesstoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetaccessToken =
        prefs.setString('accesstoken', accesstoken);
        print("accesstoken: $accesstoken");
    return didsetaccessToken;
  }

  /// logout tokem 삭제
  deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accesstoken');
    await prefs.remove('refreshtoken');
  }
}
