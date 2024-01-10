import 'dart:convert';

import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class HomePageController extends GetxController {
  // property
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> rangeStartDay = DateTime.now().obs;
  Rx<DateTime?> rangeEndDay = DateTime.now().obs;

  // 서버에서 데이터 가져와 넣어둘
  RemoteDatasourceImpl datasourse = RemoteDatasourceImpl();

  TokenHandler tokenHandler = TokenHandler();
  String token = '';

  var dataConvertedJSON;
  RxList pacsData = [].obs; // 전체 데이터
  RxList<HomePageTableData> homePageData = <HomePageTableData>[].obs;
  // RxList<HomePageTableData> studyDetailData = <HomePageTableData>[].obs;
  RxList studyDetailData = [].obs;

  // late DateTime? rangeStartDay;

  // late DateTime? rangeEndDay;

  //

  @override
  void onInit() async {
    await fetchTokenData();
    onRangeSelected(rangeStartDay.value, rangeEndDay.value, focusedDay.value);
    await getJSONData();
    super.onInit();
  }

  String formatRangeDate(DateTime? beforeFormatDate) {
    String afterFormatDate;
    beforeFormatDate != null
        ? afterFormatDate = DateFormat('yyyy-MM-dd').format(beforeFormatDate)
        : afterFormatDate = "";

    return afterFormatDate;
  }

  onRangeSelected(DateTime? rangeStart, DateTime? rangeEnd, DateTime focused) {
    focusedDay.value = focused;
    rangeStartDay.value = rangeStart;
    rangeEndDay.value = rangeEnd;
  }

  /// AccessToken 가져오기
  fetchTokenData() async {
    token = await tokenHandler.getAccessToken();
    // return token;
  }

  /// 서버에서 데이터 가져오기
  getJSONData() async {
    pacsData.clear();
    String addurl = 'studies/';
    String? baseUrl = dotenv.env['baseurl'];
   
    var url = Uri.parse('$baseUrl$addurl');
    try {
      var response = await http.get(url, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {
        dataConvertedJSON = json.decode(utf8
          .decode(response.bodyBytes)); // 소스 원본을 가져와 복호화 하기. 한글이기 때문에 꼭 해줘야 함
      // print(dataConvertedJSON);
      // print("studykey :  ${dataConvertedJSON[0]['PID']}");
      pacsData.clear();
      pacsData.addAll(dataConvertedJSON);
      // print("length of pacsDataList : ${pacsData.length}");

      // print("studykey=5인 스터디의 모든 정보 : ${pacsData[4]}}");

      /// 홈페이지에서 보여줄 컬럼의 데이터 추가
      for (int i = 0; i < pacsData.length; i++) {
        homePageData.add(HomePageTableData(
            studyKey: dataConvertedJSON[i]['STUDYKEY'],
            pId: dataConvertedJSON[i]['PID'],
            pName: dataConvertedJSON[i]['PNAME'],
            modallity: dataConvertedJSON[i]['MODALITY'],
            studyDescription: dataConvertedJSON[i]['STUDYDESC'],
            studyDate: dataConvertedJSON[i]['STUDYDATE'],
            reportStatus: dataConvertedJSON[i]['REPORTSTATUS'],
            seriesCount: dataConvertedJSON[i]['SERIESCNT'],
            imageCount: dataConvertedJSON[i]['IMAGECNT'],
            examStatus: dataConvertedJSON[i]['EXAMSTATUS']));
      }
      } else {
        print("status is not 200");
      }
      
    } catch (e) {
      print('error : $e');
    }
  }

  // /// 홈페이지의 테이블을 선택했을 때 해당 검사 상세 정보 보내주기
  // showStudyDetail(int studyKey) {
  //   studyDetailData.clear();
  //   // print(pacsData[studyKey]);
  //   // studyDetailData.add(pacsData[studyKey+1]);
  //   studyDetailData.add(pacsData[studyKey]);
  //   // studyDetailData.add(
  //   //   HomePageTableData(
  //   //     pId: dataConvertedJSON[studyKey]['PID'],
  //   //     pName: dataConvertedJSON[studyKey]['PNAME'],
  //   //     modallity: dataConvertedJSON[studyKey]['MODALITY'],
  //   //     studyDescription: dataConvertedJSON[studyKey]['STUDYDESC'],
  //   //     studyDate: dataConvertedJSON[studyKey]['STUDYDATE'],
  //   //     reportStatus: dataConvertedJSON[studyKey]['REPORTSTATUS'],
  //   //     seriesCount: dataConvertedJSON[studyKey]['SERIESCNT'],
  //   //     imageCount: dataConvertedJSON[studyKey]['IMAGECNT'],
  //   //     examStatus: dataConvertedJSON[studyKey]['EXAMSTATUS']
  //   //   )
  //   // );
  //   print("선택한 검사의 모든 데이터 : $studyDetailData");
  // }
}
