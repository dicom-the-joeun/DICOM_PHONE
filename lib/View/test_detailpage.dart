import 'package:cached_network_image/cached_network_image.dart';
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
    var dataList = Get.arguments ?? [];
    int studyKey = dataList[0];
    // List seriesKey = dataList[1];
    int seriesKey = dataList[1];
    return Scaffold(
      appBar: MyAppbar(
        onChangeTheme: onChangeTheme,
        backStatus: true,
      ),
      body: Center(
        child:
            // CachedNetworkImage(
            //   imageUrl: imageUrl,
            //   ),
            Column(
          children: [
            ElevatedButton(
              onPressed: () {
                print("detail로 넘어온 studyKey: $studyKey");
                print("detail로 넘어온 seriesKey: $seriesKey");
                detailImageController.getDetailImage(
                    studyKey: studyKey, seriesKey: seriesKey);
              },
              child: const Text("Test불러오기"),
            ),
            ElevatedButton(
              onPressed: () {
                detailImageController.getFileLink(
                    studyKey: studyKey, seriesKey: seriesKey);
              },
              child: const Text("FileLink"),
            ),
            Obx( ()
              => SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: detailImageController.detailList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: CachedNetworkImage(
                        imageUrl:
                            detailImageController.getThumbnailUrl(index: index),
                        httpHeaders: {
                          'accept': 'application/json',
                          'Authorization':
                              "Bearer ${detailImageController.token}",
                        },
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
