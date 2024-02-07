// import 'dart:convert';


// import 'package:dicom_phone/DataSource/remote_datasource.dart';
// import 'package:dicom_phone/DataSource/token_handler.dart';
// import 'package:dicom_phone/Model/detailpage_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;


// abstract class Details{
//   Future getDetail(int studyKey, int seriesKey);
// }

// class Detail extends GetxController implements Details{
//   RemoteDatasourceImpl datasource = RemoteDatasourceImpl();
//   final TokenHandler _tokenHandler = TokenHandler();
//   RxList<DetailModel> detailList = <DetailModel>[].obs; // 썸네일 시리즈를 담을 리스트
//   RxString token = "".obs; // 토큰을 담을 변수
//   RxBool isLoading = true.obs;
//   final String? baseUrl = dotenv.env['baseurl'];
//   String saveZipPath = "";

//   @override
//   void onInit() async {
//     await fetchTokenData();
//     print('시작');
//     super.onInit();
//   }

//   /// 썸네일 정보 뽑기
//   @override
//   getDetail(int studyKey,int seriesKey) async {
//     // 시리즈 리스트 초기화
//     detailList.value = [];
//     isLoading.value = true;
//     // endpoint 가져오기
//     String addurl = "dcms/thumbnails?studykey=$studyKey&serieskey=$seriesKey";
//     Uri url = Uri.parse('$baseUrl$addurl');
    
//     try {
//       var response = await http.get(url, headers: {
//         'accept': 'application/json',
//         'Authorization': 'Bearer $token'
//       });
//       print('서버 응답 코드: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         // 응답 결과(리스트형식)을 담기
//         String responseBody = utf8.decode(response.bodyBytes);
//         List dataConvertedJSON = jsonDecode(responseBody);
//         // 반복문으로 studies 리스트에 study 객체 담기
//         for (var series in dataConvertedJSON) {
//           // study를 Map형식으로 담아주기
//           DetailModel tempSeries = DetailModel.fromMap(series);
//           detailList.add(tempSeries);
//         }
//         // print("serieskey: ${seriesList[index.value].serieskey}");
//         print("serieskey: ${detailList[0]}");
//         print(detailList[0].result.PATH);
//         print(detailList[0].result.FNAME);
//         isLoading.value = false;
//       } else {
//         // 200 코드가 아닌 경우 빈 리스트 리턴
//         isLoading.value = true;
//         detailList.value = [];
//       }
//     } catch (e) {
//       // 예외 처리 및 변환
//       print("서버 요청 중 오류가 발생했습니다: $e");
//       isLoading.value = true;
//     }
//   }

//   /// AccessToken 가져오기
//   fetchTokenData() async {
//     token.value = await _tokenHandler.getAccessToken();
//     print('토큰: $token');
//   }

//   /// 썸네일 이미지 url 받아오기
//   String getDetailUrl({required int index}) {
//     String resultUrl = "";
//     String imageUrl = '${baseUrl}dcms/image';
//     String path = detailList[index] .result.PATH;
//     String fname = detailList[index].result.FNAME;
//     resultUrl = '$imageUrl?filepath=$path&filename=$fname';
//     return resultUrl;
//   }

//   /// 디테일 페이지로 헤더, 시리즈키 넘기기
//   // ThumbnailModel getSeries({required int index}){

//   //   for (var resultList in seriesList) {
//   //     resultList[]
//   //   return resultList;
//   //   }
//   // }
// }
