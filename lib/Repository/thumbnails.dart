import 'dart:convert';

import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Thumbnails {
  Future getThumbnail(int studyKey);
}

class Thumbnail extends GetxController implements Thumbnails {
  RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  final TokenHandler _tokenHandler = TokenHandler();
  RxList<ThumbnailModel> seriesList = <ThumbnailModel>[].obs; // 썸네일 시리즈를 담을 리스트
  String token = ""; // 토큰을 담을 변수
  RxBool isLoading = true.obs;
  final String? baseUrl = dotenv.env['baseurl'];
  String saveZipPath = "";

  @override
  void onInit() async {
    await fetchTokenData();
    super.onInit();
  }

  /// 썸네일 정보 뽑기
  @override
  getThumbnail(int studyKey) async {
    // 시리즈 리스트 초기화
    seriesList.value = [];
    isLoading.value = true;
    // endpoint 가져오기
    String addurl = "dcms/thumbnails?studykey=$studyKey";
    Uri url = Uri.parse('$baseUrl$addurl');
    try {
      var response = await http.get(url, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        // 응답 결과(리스트형식)을 담기
        String responseBody = utf8.decode(response.bodyBytes);
        List dataConvertedJSON = jsonDecode(responseBody);
        // 반복문으로 studies 리스트에 study 객체 담기
        for (var series in dataConvertedJSON) {
          // study를 Map형식으로 담아주기
          ThumbnailModel tempSeries = ThumbnailModel.fromMap(series);
          seriesList.add(tempSeries);
        }
        // print("serieskey: ${seriesList[index.value].serieskey}");
        print("serieskey: ${seriesList[0].headers}");
        print(seriesList[0].fname);
        print(seriesList[0].path);
        isLoading.value = false;
      } else {
        // 200 코드가 아닌 경우 빈 리스트 리턴
        isLoading.value = true;
        seriesList.value = [];
      }
    } catch (e) {
      // 예외 처리 및 변환
      print("서버 요청 중 오류가 발생했습니다: $e");
      isLoading.value = true;
    }
  }

  /// AccessToken 가져오기
  fetchTokenData() async {
    token = await _tokenHandler.getAccessToken();
  }

  /// 썸네일 이미지 url 받아오기
  String getThumbnailUrl({required int index}) {
    String resultUrl = "";
    String imageUrl = '${baseUrl}dcms/image';
    String path = seriesList[index].path;
    String fname = seriesList[index].fname;
    resultUrl = '$imageUrl?filepath=$path&filename=$fname';
    return resultUrl;
  }

  /// 디테일 페이지로 헤더, 시리즈키 넘기기
  // ThumbnailModel getSeries({required int index}){

  //   for (var resultList in seriesList) {
  //     resultList[]
  //   return resultList;
  //   }
  // }
}
