import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicom_phone/Detailpage.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SireisListviewPage extends StatelessWidget {
  const SireisListviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Thumbnail thumbnail = Get.put(Thumbnail());
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
              onPressed: () => thumbnail.getThumbnail(2),
              child: const Text('썸네일'),
            ),
            Obx(
              () => thumbnail.seriesList.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: thumbnail.seriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "검사일자: ${thumbnail.seriesList[index].headers['Study Date']}"),
                                    Text(
                                        "SeriesNumber: ${thumbnail.seriesList[index].headers["Series Number"]}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "환자명: ${thumbnail.seriesList[index].headers["Patient's Name"]}"),
                                    Text(
                                        "환자나이: 만 ${calculateAge(thumbnail.seriesList[index].headers["Patient's Birth Date"])}세"),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red)),
                                  child: CachedNetworkImage(
                                    imageUrl: thumbnail.getThumbnailUrl(
                                      index: index,
                                    ),
                                    httpHeaders: {
                                      'accept': 'application/json',
                                      'Authorization':
                                          "Bearer ${thumbnail.token.value}",
                                    },
                                    // width: 300,
                                    // height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
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

  // --- Functions ---
  calculateAge(String birthDate) {
    // 현재 날짜
    DateTime now = DateTime.now();

    // 생년월일을 DateTime으로 변환
    DateTime birthday = DateTime.parse(birthDate);

    // 현재 나이 계산
    int age = now.year - birthday.year;

    // 현재 월과 생일 월 비교
    if (now.month < birthday.month) {
      // 아직 생일이 안 지났으면 1살 빼기
      age--;
    } else if (now.month == birthday.month && now.day < birthday.day) {
      // 생일이 지났지만, 아직 생일이 안 지났으면 1살 빼기
      age--;
    }

    return age;
  }
}
