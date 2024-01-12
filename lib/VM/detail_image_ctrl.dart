import 'dart:convert';
import 'dart:io';

import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Model/detailpage_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DetailImageController extends GetxController {
  final TokenHandler _tokenHandler = TokenHandler();
  final String? baseUrl = dotenv.env['baseurl'];
  String token = "";
  String fname = "";
  String path = "";
  RxList<DetailModel> detailList = <DetailModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    token = await _tokenHandler.fetchData();
    super.onInit();
  }

  /// image zip파일 받아오기
  getFileLink({required int studyKey, required int seriesKey}) async {
    final String addurl =
        'dcms/image/compressed?studykey=$studyKey&serieskey=$seriesKey';

    try {
      var response = await http.get(Uri.parse('$baseUrl$addurl'), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      // 앱의 로컬 디렉토리 얻기
      final directory = await getApplicationDocumentsDirectory();
      String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
      final filePath = '${directory.path}/${formattedDate}sample.zip';

      var file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('파일이 다운로드되었습니다. 경로: $filePath');
    } catch (e) {
      print('error $e');
    }
  }

  getDetailImage({required int studyKey, required int seriesKey}) async {
    detailList.value = [];
    final String addurl =
        'dcms/details?studykey=$studyKey&serieskey=$seriesKey';

    try {
      var response = await http.get(Uri.parse('$baseUrl$addurl'), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        print(response.statusCode);
        String responseBody = utf8.decode(response.bodyBytes);

        // List<dynamic>에서 List<Map<String, dynamic>>로 변환
        List<Map<String, dynamic>> result =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody)['result']);

        // 각 이미지에 대한 정보를 처리
        for (var imageInfo in result) {
          fname = imageInfo['FNAME'];
          path = imageInfo['PATH'];

          // 이제 fname와 path를 사용할 수 있습니다.
          print('FNAME: $fname, PATH: $path');

          // 필요한 경우 DetailModel을 초기화하여 리스트에 추가
          // DetailModel tempModel = DetailModel.fromMap(imageInfo);
          // detailList.add(tempModel);
        }
        isLoading.value = false;
      } else {
        print("detail image 불러오기 실패");
        isLoading.value = true;
      }
    } catch (e) {
      print('error $e');
      isLoading.value = true;
    }
  }

  /// 썸네일 이미지 url 받아오기
  String getThumbnailUrl({required int index}) {
    String resultUrl = "";
    String imageUrl = '${baseUrl}dcms/image';
    // String fname = detailList[index].result.FNAME;
    // String path = detailList[index].result.PATH;
    resultUrl = '$imageUrl?filepath=$path&filename=$fname';
    return resultUrl;
  }
}
