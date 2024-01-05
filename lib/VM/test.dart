// import 'package:dicom_phone/VM/remote_datasource.dart';
// import 'package:dio/dio.dart';
// import 'package:exec_riverpod_gorouter/data/remote_datasource.dart';
// import 'package:exec_riverpod_gorouter/model/user.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// abstract class UserRepository {
//   Future<bool> userCreate(User user);
//   Future<bool> userLogin(User user);
//   Future<String> getAccessToken();
//   Future<String> getRefreshToken();
// }

// enum URL {
//   refresh('/refresh'),
//   login('/login'),
//   create('/user');

//   const URL(this.value);
//   final String value;
// }

// class UserRepositoryImpl implements UserRepository {
//   final RemoteDatasource _datasource;

//   UserRepositoryImpl(this._datasource);

//   @override
//   Future<String> getAccessToken() async {
//     final String url = URL.refresh.value;
//     final String token = await getRefreshToken();
//     final Map<String, dynamic> tokenheaders = {'refresh-token': token};

//     final response = await _datasource.get(url, headers: tokenheaders);
//     if (response != null) {
//       Logger().d(response);
//       Response<dynamic> resData = response;
//       Map<String, dynamic> mapData = resData.headers.map;
//       String accesstoken = mapData['access_token'].first;
//       await _setAccessToken(accesstoken);
//       return accesstoken;
//     }
//     throw Exception('Failed to get access token');
//   }

//   @override
//   Future<bool> userCreate(User user) async {
//     final String url = URL.create.value;
//     final Map<String, dynamic> data = user.toJson();
//     final response = await _datasource.post(url, data);
//     if (response != null) {
//       Logger().d(response);
//       Response<dynamic> _ = response;
//       return true;
//     }
//     return false;
//   }

//   @override
//   Future<bool> userLogin(User user) async {
//     final String url = URL.login.value;
//     String data =
//         'username=${user.id}&password=${user.password}&grant_type=&scope=&client_id=&client_secret=';
//     final Map<String, dynamic> headers = {
//       'Content-Type': 'application/x-www-form-urlencoded'
//     };
//     final response = await _datasource.post(url, data, headers: headers);
//     if (response != null) {
//       Logger().d(response);
//       Response<dynamic> resData = response;
//       Map<String, dynamic> mapData = resData.headers.map;
//       String? accesstoken = mapData['access_token'].first;
//       String? refreshtoken = mapData['refresh_token'].first;
//       if (await _setAccessToken(accesstoken!) &&
//           await _setRefreshToken(refreshtoken!)) {
//         return true;
//       }
//       return false;
//     }
//     return false;
//   }

//   @override
//   Future<String> getRefreshToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String hasSeenOnboarding = prefs.getString('refreshtoken') ?? '';
//     return hasSeenOnboarding;
//   }

//   Future<bool> _setRefreshToken(String refreshtoken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Future<bool> didsetrefreshToken =
//         prefs.setString('refreshtoken', refreshtoken);
//     return didsetrefreshToken;
//   }

//   Future<bool> _setAccessToken(String accesstoken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Future<bool> didsetaccessToken =
//         prefs.setString('accesstoken', accesstoken);
//     return didsetaccessToken;
//   }
// }
