
import 'package:dicom_phone/VM/remote_datasource.dart';
import 'package:dicom_phone/util/api_endpoint.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    RemoteDatasourceImpl _datasource = RemoteDatasourceImpl();

    bool loginStatus = false;
    String url = dotenv.env['baseurl']! + APiEndPoints.apiEndPoints.login;
    String data =
        'username=$username&password=$password&grant_type=&scope=&client_id=&client_secret=';
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final response = await _datasource.post(url, data, headers: headers);
    if (response != null) {
      Logger().d(response);
      dio.Response<dynamic> resData = response;
      print(resData.statusCode);
      Map<String, dynamic> mapData = resData.headers.map;
      String? accesstoken = mapData['access_token'].first;
      String? refreshtoken = mapData['refresh_token'].first;
      if (await _setAccessToken(accesstoken!) &&
          await _setRefreshToken(refreshtoken!)) {
        return loginStatus = true;
      }
      return loginStatus = false;
    }
    return loginStatus;
  }




    @override
  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hasSeenOnboarding = prefs.getString('refreshtoken') ?? '';
    return hasSeenOnboarding;
  }

  Future<bool> _setRefreshToken(String refreshtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> didsetrefreshToken =
        prefs.setString('refreshtoken', refreshtoken);
    return didsetrefreshToken;
  }

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









// Future<bool> checkLogin(String username, String password) async {
//   bool loginStatus = false;
//   String baseUrl = dotenv.env['baseurl']! + APiEndPoints.apiEndPoints.login;

//   RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
//   Map<String, dynamic> data = {
//     'username': username,
//     'password': password,
//   };

//   try {
//     var response = await datasource.post(baseUrl, data, headers: {
//       'accept': 'application/json',
//       'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//     });
//     // var response = await datasource.post(baseUrl, data);
//     if (response is ResponseResult && response == ResponseResult.error) {
//       // post 메서드에서 오류가 발생한 경우
//       loginStatus = false;
//       print('로그인 실패');
//     } else {
//       // post 메서드에서 성공적으로 응답을 받은 경우
//       // 여기에 로그인 성공 처리를 추가할 수 있습니다.
//       loginStatus = true;
//     }
//   } catch (error) {
//     // post 메서드 호출 자체에서 오류가 발생한 경우
//     loginStatus = false;
//     print('post 메서드 호출 중 오류 발생: $error');
//   }

//   return loginStatus;
// }






//   Future<bool> checkLogin(String username, String password) async {
//     bool loginStatus = false; // 이 부분 추가
//     String baseUrl = dotenv.env['baseurl']! + APiEndPoints.apiEndPoints.login;

//     RemoteDatasource datasource = RemoteDatasourceImpl();

//     datasource.post(
//       baseUrl,
//       data,
//     );
// //     Map<String, dynamic> data = {
// //       'username': username,
// //       'password': password,
// //     };
// //     try {
// //       final http.Response response = await http.post(
// //         url,
// //         headers: {
// //           'accept': 'application/json',
// //           'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
// //         },
// //         body: data,
// //       );

// //     final Uri url = Uri.parse(baseUrl);

// // // 로그인에 사용될 데이터

// //       if (response.statusCode == 200) {
// //         // 로그인 성공
// //         loginStatus = true;
// //         String responseBody = utf8.decode(response.bodyBytes);
// //         Map<String,dynamic> dataConvertedJSON = jsonDecode(responseBody);
// //         Map<String,String> dataConvertedJSONHeaders = response.headers;
// //         print('로그인 성공');
// //         print('응답 데이터: ${dataConvertedJSON['result']}');
// //         print('Access Token: ${dataConvertedJSONHeaders['access_token']}');
// //       } else {
// //         // 로그인 실패
// //         loginStatus = false;
// //         print('로그인 실패');
// //         // print('응답 코드: ${response.statusCode}');
// //         // print('응답 데이터: ${response.body}');
// //       }
// //     } catch (error) {
// //       // 에러 처리
// //       print('오류 발생: $error');
// //     }

//     return loginStatus;
//   }
