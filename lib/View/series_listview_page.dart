import 'package:dicom_phone/Detailpage.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SireisListviewPage extends StatelessWidget {
  const SireisListviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = Thumbnail();
    List imageList = [
      "images/Apple.png",
      "images/Banana.png",
      "images/Grape.png",
      "images/Orange.png",
    ];
    int studyKey = 1;
    int serieskey = 1;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const DetailPage()),
              child: const Text('상세페이지 이동'),
            ),
            ElevatedButton(
              onPressed: () => thumbnail.getThumbnail(studyKey, serieskey),
              child: const Text('썸네일'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    imageList[index],
                    width: 300,
                    height: 300,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
