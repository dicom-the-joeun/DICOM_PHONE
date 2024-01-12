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
  /// property (서버에서 데이터 가져오기)
  RemoteDatasourceImpl datasourse = RemoteDatasourceImpl();
  TokenHandler tokenHandler = TokenHandler();
  String token = '';
  late List dataConvertedJSON;
  RxList pacsData = [].obs; // 전체 데이터
  RxList<HomePageTableData> homePageData = <HomePageTableData>[].obs;
  
  /// property (검색)
  RxString selectedFilter = ''.obs;
  RxString searchText = ''.obs;
  RxList<HomePageTableData> filteredData = <HomePageTableData>[].obs;

  /// property (캘린더 날짜 범위 선택)
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> rangeStartDay = DateTime.now().obs;
  Rx<DateTime?> rangeEndDay = DateTime.now().obs;


  @override
  void onInit() async {
    token = await tokenHandler.fetchData();
    print("token: $token");
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
  // fetchTokenData() async {
  //   token = await tokenHandler.getAccessToken();
  //   // return token;
  // }

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
      print("statusCode : ${response.statusCode}");
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
        print("검색된 데이터 : $filteredData");
        // print("home page data : ${homePageData[0]}");
        // getFilteredData();
        // print(filteredData);
        // print("검색 환자 이름 : ${filteredData.pName}");
        // print("검색 장비 명 : ${filteredData.modality}");
        // print("검색 판독 상태 : ${filteredData.verify}");
      } else {
        print("status is not 200");
      }
      
    } catch (e) {
      print('error : $e');
    }
  }

  // whereTest(String selectedSearchFilter, String searchText) {
  //   var selectedFilter = selectedSearchFilter == '환자 이름' 
  //     ? 'pName' :  selectedSearchFilter == '검사 장비'
  //     ? 'modallity' : 'reportStatus';
  //   var newData = homePageData;
  //   print("강감찬 환자의 데이터 : ${newData.where((data) => data.pName == '강감찬').toList()}");
  //   var filteredData = newData.where((data) => data.pName == searchText).toList();
  //   return filteredData;
  // }

  /// 검색 필터와 검색어를 입력했을 때 
  /// (검색 필터 == 검색어)인 데이터들을 불러와 
  /// 화면에 다시 띄워주기
  getFilteredData() {
    filteredData.clear();
    // filteredData.addAll(homePageData);
    print("필터 전 검색된 데이터 : $filteredData");
    if (selectedFilter.value == '환자 이름') {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.pName.toLowerCase().contains(searchText.toLowerCase()))
        )
      );
      print("1");
    } else if (selectedFilter.value == '검사 장비') {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.modality.toLowerCase() == (searchText.toLowerCase()))
        )
      );
      print("2");
    } else {
      filteredData.addAll(
        RxList<HomePageTableData>.of(
          homePageData.where((data) => data.reportStatus == (searchText.contains('판독') ? 6 : searchText.contains('읽지 않음') ? 3 : 5))
        )
      );
      print("3");
    }
    // filteredData = RxList<HomePageTableData>.of(
    //                 homePageData.where(
    //                   (data) => selectedFilter.value == '환자 이름' ? data.pName.toLowerCase().contains(searchText.toLowerCase())
    //                     : selectedFilter.value == '검사 장비' ? data.modallity.toLowerCase().contains(searchText.toLowerCase())
    //                     : data.reportStatus == (searchText.contains('판독') ? 6 : searchText.contains('읽지 않음') ? 3 : 5)
    //                 )
    //               );
    // filteredData = 
    //   selectedFilter.value == '환자 이름' ?
    //     RxList<HomePageTableData>.of(
    //       homePageData.where((data) => data.pName.toLowerCase().contains(searchText.toLowerCase()))
    //     )
    //     : selectedFilter.value == '검사 장비' ?
    //       RxList<HomePageTableData>.of(
    //         homePageData.where((data) => data.modality.toLowerCase() == (searchText.toLowerCase()))
    //       )
    //       : RxList<HomePageTableData>.of(
    //         homePageData.where((data) => data.reportStatus == (searchText.contains('판독') ? 6 : searchText.contains('읽지 않음') ? 3 : 5))
    //       );
    print("필터 후 검색된 데이터 : $filteredData");
    // filteredData.clear();
    // var allData = homePageData;
    
    // var filterCondition = allData.where(
    //                     (data) => selectedFilter == '환자 이름' 
    //                     ? data.pName == searchText
    //                     : selectedFilter == '검사 장비'
    //                     ? data.modallity == searchText
    //                     : data.reportStatus == (searchText == '판독' ? 6 : searchText == '읽지않음' ? 3 : 5)
    //                   );
    
    // // print("강감찬 환자의 데이터 : ${newData.where((data) => data.pName == '강감찬').toList()}");
    // // print("강감찬 환자의 데이터 : ${allData.where((data) => data.selectedFilter == searchText).toList()}");
    // // var filteredData = allData.where((data) => data.pName == searchText).toList();
    // // return filteredData;
    // print("getFilteredData() 함수 실행 끝 : $filteredData");
  }




}
