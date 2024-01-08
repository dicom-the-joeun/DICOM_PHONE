import 'dart:convert';

import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:dicom_phone/VM/remote_datasource.dart';
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
  List pacsData = [];           // 전체 데이터
  List homePageData = [];

  // late DateTime? rangeStartDay;

  // late DateTime? rangeEndDay;

  // 

  @override
  void onInit() {
    onRangeSelected(rangeStartDay.value, rangeEndDay.value, focusedDay.value);
    getJSONData();
    super.onInit();
  }

  String formatRangeDate(DateTime? beforeFormatDate) {
    String afterFormatDate;
    beforeFormatDate != null  
    ? afterFormatDate = DateFormat('yyyy-MM-dd').format(beforeFormatDate) 
    : afterFormatDate = "" ;
  
    return afterFormatDate;
  }

  onRangeSelected(DateTime? rangeStart, DateTime? rangeEnd, DateTime focused) {
    focusedDay.value = focused;
    rangeStartDay.value = rangeStart;
    rangeEndDay.value = rangeEnd;

  }

  /// 서버에서 데이터 가져오기
  getJSONData() async {
    pacsData.clear();
    String addurl = 'studies/';
    String? baseUrl = dotenv.env['baseurl'];
    Map<String, dynamic>? headers = {
      'accept' : 'application/json'
    };
     var url = Uri.parse('$baseUrl$addurl');
     var response = await http.get(url);
    // print(response);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));   // 소스 원본을 가져와 복호화 하기. 한글이기 때문에 꼭 해줘야 함
    print(dataConvertedJSON);
    print("studykey :  ${dataConvertedJSON[0]['STUDYKEY']}");
    pacsData.addAll(dataConvertedJSON);
  }

  /// 홈페이지에서 보여줄 컬럼의 데이터만 분류
  getHomePageData() {
    for (var data in pacsData) {
      // homePageData.add(HomePageTableData(pName: pName, modallity: modallity, studyDescription: studyDescription, studyDate: studyDate, examStatus: examStatus))
    }
  }




}