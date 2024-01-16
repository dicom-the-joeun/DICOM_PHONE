import 'dart:convert';

import 'package:dicom_phone/DataSource/remote_datasource.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart' as dio;

class HomePageController extends GetxController {
  /// property (서버에서 데이터 가져오기)
  RemoteDatasourceImpl datasourse = RemoteDatasourceImpl();
  // TokenHandler tokenHandler = TokenHandler();
  final TokenHandler _tokenHandler = Get.put(TokenHandler());
  String token = '';
  late List dataConvertedJSON;
  RxList pacsData = [].obs; // 전체 데이터
  RxList<HomePageTableData> homePageData = <HomePageTableData>[].obs;
  
  /// property (검색)
  final List<String>  valueList = ['환자 이름', '검사 장비', '판독 상태'];
  RxString selectedValue = '환자 이름'.obs;
  RxString selectedFilter = '환자 이름'.obs;
  TextEditingController searchTextController = TextEditingController();
  RxString searchText = ''.obs;
  RxList<HomePageTableData> filteredData = <HomePageTableData>[].obs;

  /// property (캘린더 날짜 범위 선택)
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> rangeStartDay = DateTime.now().obs;
  Rx<DateTime?> rangeEndDay = DateTime.now().obs;


  @override
  void onInit() async {
    await _tokenHandler.init();
    token = _tokenHandler.token;
    // onRangeSelected(rangeStartDay.value, rangeEndDay.value, focusedDay.value);
    await getJSONData();
    super.onInit();
  }

  String formatRangeDate(DateTime? beforeFormatDate) {
    String afterFormatDate;
    beforeFormatDate != null
        ? afterFormatDate = DateFormat('yyyy-MM-dd').format(beforeFormatDate)
        : afterFormatDate = "";
    print("여긴 날짜 포맷 함수_startDay : ${rangeStartDay.value}");
    print("여긴 날짜 포맷 함수_endDay : ${rangeEndDay.value}");
    return afterFormatDate;
  }

  /// 캘린더 - 범위 선택 함수
  onRangeSelected(DateTime? rangeStart, DateTime? rangeEnd, DateTime focused) async {
    focusedDay.value = focused;
  // DateTime startDay = rangeStart!;
  //   DateTime endDay = rangeEnd ?? DateTime.now();
  //   rangeStartDay.value = startDay;
  //   rangeEndDay.value = endDay;
    
    // rangeStartDay.value = rangeStart;
    // rangeEndDay.value = rangeEnd;
    // update();
    // print("start day : ${rangeStartDay.value}");
    // print("end day : ${rangeEndDay.value}");
    DateTime startDay;
    DateTime endDay;
    if (rangeEnd == null) {
      startDay = rangeStart!;
      endDay = rangeStart;
      // rangeStartDay.value = rangeStart;
      // rangeEndDay.value = rangeStart;
    } else {
      startDay = rangeStart!;
      endDay = rangeEnd;
    }
    rangeStartDay.value = startDay;
    rangeEndDay.value = endDay;
  }

  /// 서버에서 데이터 가져오기
  getJSONData() async {
    pacsData.clear();
    homePageData.clear();
    
    String addurl = 'studies/';
    String? baseUrl = dotenv.env['baseurl'];
    
    var url = Uri.parse('$baseUrl$addurl');
    try {
      var response = await http.get(url, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      // print("statusCode : ${response.statusCode}");
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
        // homePageData.clear();
        for (int i = 0; i < pacsData.length; i++) {
          homePageData.add(
            HomePageTableData(
              studyKey: dataConvertedJSON[i]['STUDYKEY'],
              pId: dataConvertedJSON[i]['PID'],
              pName: dataConvertedJSON[i]['PNAME'],
              modality: dataConvertedJSON[i]['MODALITY'],
              studyDescription: dataConvertedJSON[i]['STUDYDESC'],
              studyDate: dataConvertedJSON[i]['STUDYDATE'],
              reportStatus: dataConvertedJSON[i]['REPORTSTATUS'],
              seriesCount: dataConvertedJSON[i]['SERIESCNT'],
              imageCount: dataConvertedJSON[i]['IMAGECNT'],
              examStatus: dataConvertedJSON[i]['EXAMSTATUS']
            )
          );
        }
        filteredData.addAll(homePageData);
        // print(homePageData);
      } else {
        print("status is not 200");
      }
      
    } catch (e) {
      print('error : $e');
    }
  }

  /// 검색 필터와 검색어를 입력했을 때 
  /// (검색 필터 == 검색어)인 데이터들을 불러와 
  /// 화면에 다시 띄워주기
  getFilteredData() {
    filteredData.clear();
    if (selectedFilter.value == '환자 이름') {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.pName.toLowerCase().contains(searchTextController.text.trim().toLowerCase()))
        )
      );
    } else if (selectedFilter.value == '검사 장비') {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.modality.toLowerCase() == (searchTextController.text.trim().toLowerCase()))
        )
      );
    } else {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.reportStatus == (searchTextController.text.trim().contains('판독') ? 6 : searchTextController.text.trim().contains('읽지 않음') ? 3 : 5))
        )
      );
    }
  }

  /// 캘린더에서 선택한 범위의 날짜 보여주기
  String getSelectedRangeDate() {
    // print("함수에서 범위 시작 : ${rangeStartDay.value}");
    // print("함수에서 범위 끝 : ${rangeEndDay.value}");
    String text = "";
    if ((rangeStartDay.value != null) && (rangeEndDay.value != null)) {
      text = 
      "${DateFormat("yyyy-MM-dd").format(rangeStartDay.value!)}   ~   ${DateFormat("yyyy-MM-dd").format(rangeEndDay.value!)}";
    } else {
      text = "";
    }
    if (DateFormat("yyyy-MM-dd").format(rangeStartDay.value!) == DateFormat("yyyy-MM-dd").format(rangeEndDay.value!)) {
      text = DateFormat("yyyy-MM-dd").format(rangeStartDay.value!);
    }
    return text;
  }

}
