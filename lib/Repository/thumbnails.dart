import 'dart:convert';

// import 'package:dicom_phone/DataSource/remote_datasource.dart';
// import 'package:dio/dio.dart' as dio;
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Thumbnails {
  Future getThumbnail(int studyKey, int serieskey);
}

class Thumbnail implements Thumbnails {
  // RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
  @override
  Future<List<ThumbnailModel>> getThumbnail(int studyKey, int serieskey) async {
    final String? baseUrl = dotenv.env['baseurl'];
    String addurl = "dcms/thumbnails?studykey=$studyKey&serieskey=$serieskey";
    Uri url = Uri.parse('$baseUrl$addurl');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(response.body);

    List<dynamic> resultList = dataConvertedJSON;

    // resultList의 각 항목을 ThumbnailModel로 변환
    List<ThumbnailModel> thumbnailList = resultList.map((res) {
      return ThumbnailModel.fromMap(res);
    }).toList();

    // 변환된 리스트 확인
    print(thumbnailList.first.serieskey);
    print(thumbnailList.first.headers);
    print(thumbnailList.first.path);
    print(thumbnailList.first.fname);
    return thumbnailList;
  }

}
