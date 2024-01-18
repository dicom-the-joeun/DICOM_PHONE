import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Model/detailpage_model.dart';
import 'package:dicom_phone/Model/imagekey.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DetailImageController extends GetxController {
  // final TokenHandler _tokenHandler = TokenHandler();
  final TokenHandler _tokenHandler = Get.find();

  final String? baseUrl = dotenv.env['baseurl'];
  String token = "";
  String fname = "";
  String path = "";
  RxList<DetailModel> detailList = <DetailModel>[].obs;
  RxBool isLoading = true.obs;
  String saveFilePath = "";
  String zipFilePath = ""; // 파일 경로를 저장할 변수를 함수 밖에서 선언
  RxString destinationDirectory = "".obs;
  RxList<String> imagePathList = <String>[].obs;
  RxBool zipStatus = false.obs;

  // Slider 변수
  RxDouble sliderValue = 0.0.obs;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() async {
    await _tokenHandler.init();
    token = _tokenHandler.token;
    await getFileLink(
        studyKey: ImageKey.studyKey, seriesKey: ImageKey.seriesKey);
    super.onInit();
  }

  /// image zip파일 받아오기
  getFileLink({required int studyKey, required int seriesKey}) async {
    zipStatus.value = false;
    final String addurl =
        'dcms/image/compressed?studykey=$studyKey&serieskey=$seriesKey';
        // 'dcms/image/compressed?studykey=$studyKey';
    saveFilePath = "";

    try {
      var response = await http.get(Uri.parse('$baseUrl$addurl'), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      // 앱의 로컬 디렉토리 얻기
      final directory = await getApplicationDocumentsDirectory();
      String formattedDate =
          DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
      zipFilePath =
          '${directory.path}/${formattedDate}sample.zip'; // zipFilePath에 파일 경로 저장
      var file = File(zipFilePath);
      await file.writeAsBytes(response.bodyBytes);
      print('파일이 다운로드되었습니다. 경로: $zipFilePath');
      await zipOpen();
      zipStatus.value = true;
    } catch (e) {
      print('error $e');
      zipStatus.value = false;
    }
  }

  /// zip파일 압축풀고 절대경로에 저장하기
  zipOpen() async {
    final directory = await getApplicationDocumentsDirectory();
    imagePathList.clear();
    String formattedDate =
        DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    // file이름을 현재시간으로 설정   
    final destinationDirectory = '${directory.path}/${formattedDate}sample';
    File zipFile = File(zipFilePath);

    if (zipFile.existsSync()) {
      List<int> bytes = zipFile.readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(Uint8List.fromList(bytes));

      // 파일 내부에서 파일 이름을 뽑는 부분
      for (ArchiveFile file in archive) {
        String fileName = '$destinationDirectory/${file.name}';
        File outFile = File(fileName);
        outFile.parent.createSync(recursive: true); // 디렉토리가 없으면 생성

        if (file.isFile) {
          outFile.writeAsBytesSync(file.content as List<int>);
          // imagePathList에 파일 경로 추가
          imagePathList.add(outFile.path);
        } else {
          Directory(fileName).create(recursive: true);
        }
      }

      print('압축 파일이 성공적으로 해제되었습니다.');
    } else {
      print('지정된 압축 파일이 존재하지 않습니다.');
    }
  }

  /// 디테일 이미지 정보, url뽑기
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

          print('FNAME: $fname, PATH: $path');

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

  /// 디렉토리에 계속 쌓이지않게 삭제시키기
  deleteDirectoryFile() async {
    final directory = await getApplicationDocumentsDirectory();

    // 디렉토리 내용을 확인하고 파일을 삭제
    if (directory.existsSync()) {
      directory.listSync().forEach((FileSystemEntity file) {
        if (file is File) {
          file.deleteSync();
        } else if (file is Directory) {
          file.deleteSync(recursive: true);
        }
      });
    }
  }

  /// slider의 index를 바꿔주는 함수
  void changeImage(double value) {
    int index = (value * (imagePathList.length - 1)).round();

    currentIndex.value = index;
    sliderValue.value = value;
  }

  /// 썸네일 이미지 url 받아오기
  String getThumbnailUrl({required int index}) {
    String resultUrl = "";
    String imageUrl = '${baseUrl}dcms/image';
    print("@@@ imageUrl: $imageUrl");
    // String fname = detailList[index].result.FNAME;
    // String path = detailList[index].result.PATH;
    resultUrl = '$imageUrl?filepath=$path&filename=$fname';
    print("@@@ resultUrl: $resultUrl");
    return resultUrl;
  }
}
