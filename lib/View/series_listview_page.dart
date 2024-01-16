import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicom_phone/Detailpage.dart';
import 'package:dicom_phone/Model/imagekey.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:dicom_phone/View/myappbar.dart';
import 'package:dicom_phone/View/test_detailpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SireisListviewPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const SireisListviewPage({
    super.key,
    required this.onChangeTheme,
  });

  @override
  Widget build(BuildContext context) {
    final Thumbnail thumbnail = Get.put(Thumbnail());
    var studyKey = Get.arguments ?? 1;

    return Scaffold(
      appBar: MyAppbar(onChangeTheme: onChangeTheme, backStatus: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const DetailPage()),
              child: const Text('상세페이지 이동'),
            ),
            Obx(
              () => Column(
                children: [
                  Switch(
                    value: thumbnail.listMode.value,
                    onChanged: (value) {
                      thumbnail.listMode.value = value;
                    },
                  ),
                  Text(
                    thumbnail.listMode.value
                    ? "시리즈 모드"
                    : "리스트 모드"
                  ),
                ],
              ),
            ),
            Obx(
              () => thumbnail.isLoading.value
                  ? const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        Text("이미지 불러오는중 ..."),
                      ],
                    )
                  : !thumbnail.listMode.value
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.70,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: thumbnail.seriesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              ThumbnailModel currentSeries =
                                  thumbnail.seriesList[index];
                              return GestureDetector(
                                onTap: () {
                                  ImageKey.studyKey = studyKey;
                                  ImageKey.seriesKey = currentSeries.serieskey;
                                  Get.to(
                                    () => TestDetailPage(
                                        onChangeTheme: onChangeTheme),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "검사장비 모델명: ${thumbnail.seriesList[index].headers["Manufacturer's Model Name"] ?? "정보없음"}"),
                                          Text(
                                              "   seriesKey: ${currentSeries.serieskey}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "검사일자: ${thumbnail.seriesList[index].headers['Study Date'] ?? "정보없음"}"),
                                          Text(
                                              "SeriesNumber: ${thumbnail.seriesList[index].headers["Series Number"] ?? "정보없음"}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "환자명: ${thumbnail.seriesList[index].headers["Patient's Name"] ?? "정보없음"}"),
                                          Text(
                                              "환자나이: ${calculateAge(thumbnail.seriesList[index].headers["Patient's Birth Date"] ?? "정보없음")}"),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red)),
                                        child: CachedNetworkImage(
                                          imageUrl: thumbnail.getThumbnailUrl(
                                            index: index,
                                          ),
                                          httpHeaders: {
                                            'accept': 'application/json',
                                            'Authorization':
                                                "Bearer ${thumbnail.token}",
                                          },
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.70,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: thumbnail.seriesList.length ==
                                      1 //1 개의 행에 보여줄 item 개수
                                  ? 1
                                  : 2,
                              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                              mainAxisSpacing: 5, //수평 Padding
                              crossAxisSpacing: 5, //수직 Padding
                            ),
                            itemCount: thumbnail.seriesList.length,
                            itemBuilder: (context, index) {
                              ThumbnailModel currentSeries =
                                  thumbnail.seriesList[index];
                              return GestureDetector(
                                // DetailC
                                onTap: () {
                                  // getDetailImage();
                                  Get.to(
                                      () => TestDetailPage(
                                          onChangeTheme: onChangeTheme),
                                      arguments: [
                                        studyKey,
                                        currentSeries.serieskey
                                      ]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red)),
                                    child: CachedNetworkImage(
                                      imageUrl: thumbnail.getThumbnailUrl(
                                        index: index,
                                      ),
                                      httpHeaders: {
                                        'accept': 'application/json',
                                        'Authorization':
                                            "Bearer ${thumbnail.token}",
                                      },
                                      fit: BoxFit.fill,
                                    ),
                                  ),
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
    // birthDate ?? null체크하기
    // 현재 날짜
    if (birthDate != "" || birthDate != 'UNKNOWN') {
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

      // 나이 범위 검사
      if (age < 0 || age > 120) {
        return "정보없음";
      }
      return "만 $age세";
    } else {
      return "정보없음";
    }
  }
}
