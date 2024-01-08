import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Thumbnails {
  Future getThumbnail(int studyKey, int serieskey);
}

class Thumbnail implements Thumbnails {
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  List<ThumbnailModel> thumbnailList = [];
  List<dynamic> resultList = [];
  String path = "";
  String fname = "";

  /// 썸네일 뽑기
  @override
  getThumbnail(int studyKey, int serieskey) async {
    thumbnailList.clear();
    resultList.clear();
    final String? baseUrl = dotenv.env['baseurl'];
    String addurl = "dcms/thumbnails?studykey=$studyKey&serieskey=$serieskey";
    Uri url = Uri.parse('$baseUrl$addurl');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(response.body);

    resultList = dataConvertedJSON;

    // resultList의 각 항목을 ThumbnailModel로 변환
    thumbnailList = resultList.map((res) {
      return ThumbnailModel.fromMap(res);
    }).toList();

    // 변환된 리스트 확인
    // print(thumbnailList.first.serieskey);
    // print(thumbnailList.first.headers);
    // print(thumbnailList.first.path);
    // print(thumbnailList.first.fname);
    path = thumbnailList.first.path;
    fname = thumbnailList.first.fname;
    await showThumbnailImage(
        thumbnailList.first.path, thumbnailList.first.fname, "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDQ3MDgyMzEsInN1YiI6ImFkbWluIn0.JEX4FLY4iZxEh1Rb2O48zl6tihmYD3I-2D7cJXSUOtY");
  }

  /// 썸네일 image 받아오기
  showThumbnailImage(String path, String fname, String auth) async {
    String addurl = "dcms/image?filepath=$path&filename=$fname";
    final Map<String, dynamic> headers = {
      'accept': 'application/json',
      'Authorization': auth,
    };

    
    try {
      final dio.Response<dynamic> response =
          await datasource.get(addurl, headers: headers);
      if (response.statusCode == 200) {
        // json.decode(response.body);
        print("headers: ${response.headers['']}");
        } else {
        print('error');
      }
    } catch (e) {
      print(ResponseResult.error);
    }
  }
}
