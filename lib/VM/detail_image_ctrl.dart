import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dicom_phone/DataSource/token_handler.dart';
import 'package:dicom_phone/Model/imagekey.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DetailImageController extends GetxController {
  // final TokenHandler _tokenHandler = Get.find();
  final TokenHandler _tokenHandler = TokenHandler();

  final String? baseUrl = dotenv.env['baseurl'];
  String token = "";
  String fname = "";
  String path = "";
  RxBool isLoading = true.obs;
  String saveFilePath = "";
  String zipFilePath = ""; // 파일 경로를 저장할 변수를 함수 밖에서 선언
  RxString destinationDirectory = "".obs;
  RxList<String> imagePathList = <String>[].obs;
  RxBool zipStatus = true.obs;

  // Slider 변수
  RxDouble sliderValue = 0.0.obs;
  
  RxInt currentIndex = 0.obs;
  
  @override
  void onInit() async {
    // await _tokenHandler.init(); // 중복실행 때문에 제거
    token = await _tokenHandler.fetchData();
    await findDuplicationDirectory(
        studyKey: ImageKey.studyKey);

    super.onInit();
  }

  /// 중복된 파일을 찾아서 있으면 그 파일로 이미지쓰고 아니면 zip파일 받아서 풀기
  findDuplicationDirectory(
      {required int studyKey}) async {
    final directory = await getApplicationDocumentsDirectory();
    String fileName = '${studyKey}';
    bool result = false;

    final destinationDirectory = '${directory.path}/$fileName';
    Directory folder = Directory(destinationDirectory);

    if (folder.existsSync()) {
      for (FileSystemEntity file in folder.listSync()) {
        if (file is File) {
          print('중복된 파일이 존재');
          await getSavedFile(fileName: fileName);
          result = true;
          break; // 중복된 파일을 찾았으면 반복문 종료
        }
      }
    }

    if (!result) {
      print('중복된 파일이 없음');
      await getFileLink(studyKey: studyKey);
    }
    return result;
  }

  /// image zip파일 받아오기
  getFileLink({required int studyKey}) async {
    final String addurl =
     'dcms/images/${studyKey.toString()}';

    saveFilePath = "";


    try {
      var response = await http.get(Uri.parse('$baseUrl$addurl'), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      // 앱의 로컬 디렉토리 얻기
       final directory = await getApplicationDocumentsDirectory();
      print(directory.path);
      zipFilePath =
          '${directory.path}/${studyKey}_images.zip'; // zipFilePath에 파일 경로 저장
      var file = File(zipFilePath);
      await file.writeAsBytes(response.bodyBytes);
      print('파일이 다운로드되었습니다. 경로: $zipFilePath');

      await zipOpen(studyKey: studyKey,);
      zipStatus.value = true;
    } catch (e) {
      print('error $e');
      zipStatus.value = false; // view에서 zipStatus.value가 false가 되면 오류창 띄워주기
    }
  }

  /// zip파일 압축풀고 절대경로에 저장하기
  zipOpen({required int studyKey}) async {
    final directory = await getApplicationDocumentsDirectory();
    imagePathList.clear();

    destinationDirectory.value = '${directory.path}/${studyKey}';
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

    } else {
      print('지정된 압축 파일이 존재하지 않습니다.');
    }
  }

 getSavedFile({required String fileName}) async {
  final directory = await getApplicationDocumentsDirectory();
   destinationDirectory.value = '${directory.path}/$fileName';

  Directory folder = Directory(destinationDirectory.value);

  // 이미 imagePathList가 초기화되어 있지 않은 경우에만 초기화
  if (imagePathList.isEmpty) {
    imagePathList.clear();

    if (folder.existsSync()) {
      // 폴더 내부의 파일들을 찾아 imagePathList에 추가
      folder.listSync().forEach((FileSystemEntity file) {
        if (file is File) {
          imagePathList.add(file.path);
        }
      });
    } else {
      print('지정된 폴더가 존재하지 않습니다.');
    }
  }
}
  /// 디렉토리에 계속 쌓이지않게 삭제시키기
  deleteDirectoryFile() async {
    final directory = await getApplicationDocumentsDirectory();

    // 디렉토리 내용을 확인하고 파일을 삭제
    if (directory.existsSync()) {
      directory.listSync().forEach((FileSystemEntity file) {
        if (file is File && file.uri.pathSegments.last.endsWith('.zip')) {
          file.deleteSync();
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

}

