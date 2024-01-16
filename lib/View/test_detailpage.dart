import 'package:dicom_phone/Model/imagekey.dart';
import 'package:dicom_phone/VM/detail_image_ctrl.dart';
import 'package:dicom_phone/View/myappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestDetailPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const TestDetailPage({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final DetailImageController detailImageController =
        Get.put(DetailImageController());
    // var dataList = Get.arguments ?? [];

    // int studyKey = dataList[0];
    // int seriesKey = dataList[1];

    return PopScope(
      onPopInvoked: (didPop) async {
        print("디테일 페이지 닫힘@@@@@@@@@");
        ImageKey.studyKey = 0;
        ImageKey.seriesKey = 0;
        await detailImageController.deleteDirectoryFile(); // 페이지 나갈때 디렉토리에서 파일 삭제
      },
      child: Scaffold(
        appBar: MyAppbar(
          onChangeTheme: onChangeTheme,
          backStatus: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     print("detail로 넘어온 studyKey: $studyKey");
              //     print("detail로 넘어온 seriesKey: $seriesKey");
              //     detailImageController.getDetailImage(
              //         studyKey: studyKey, seriesKey: seriesKey);
              //   },
              //   child: const Text("Test불러오기"),
              // ),
              Obx(
                () => detailImageController.imagePathList.isEmpty
                    ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("이미지 불러오는중 ...")
                        ],
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount:
                              detailImageController.imagePathList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red)),
                              child: Image.asset(
                                detailImageController.imagePathList[index],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
