import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicom_phone/Detailpage.dart';
import 'package:dicom_phone/Model/imagekey.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:dicom_phone/View/myappbar.dart';
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
    final thumbnail = Get.find<Thumbnail>();

    return PopScope(
      onPopInvoked: (didPop) {
        thumbnail.collectionValue.value = 1;
      },
      child: Scaffold(
        appBar: MyAppbar(onChangeTheme: onChangeTheme, backStatus: true),
        body: Center(
          child: Obx(
            () => thumbnail.isLoading.value
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 5.0,
                        ),
                      ),
                      Text(
                        "이미지 불러오는중 ...",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          // 스와이프 종료 시 호출
                          if (details.primaryVelocity! < 0) {
                            thumbnail.collectionValue.value <= 1
                                ? thumbnail.collectionValue.value = 1
                                : thumbnail.collectionValue.value--;
                          } else if (details.primaryVelocity! > 0) {
                            thumbnail.collectionValue.value >= 3
                                ? thumbnail.collectionValue.value = 3
                                : thumbnail.collectionValue.value++;
                          }
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.77,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: thumbnail.collectionValue.value,
                              childAspectRatio:
                                  1 / 1.4, //item 의 가로 1, 세로 2 의 비율
                              mainAxisSpacing: 5, //수평 Padding
                              crossAxisSpacing: 5, //수직 Padding
                            ),
                            itemCount: thumbnail.seriesList.length,
                            itemBuilder: (context, index) {
                              ThumbnailModel currentSeries =
                                  thumbnail.seriesList[index];
                              // 현재 앱의 테마 모드 확인
                              // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
                              return GestureDetector(
                                onTap: () {
                                  ImageKey.seriesKey = currentSeries.serieskey;
                                  Get.to(
                                    () => DetailPage(
                                        onChangeTheme: onChangeTheme),
                                  );
                                },
                                child: Container(
                                  // color: Theme.of(context).colorScheme.onBackground,
                                      color: Colors.grey[900],
                                  //     // : Colors.grey[200],
                                  //     : Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            resizeText(
                                              text:
                                                  "검사장비 모델명: ${thumbnail.seriesList[index].headers["Manufacturer's Model Name"] ?? "정보없음"}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                            resizeText(
                                              text:
                                                  "   seriesKey: ${currentSeries.serieskey}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            resizeText(
                                              text:
                                                  "검사일자: ${thumbnail.seriesList[index].headers['Study Date'] ?? "정보없음"}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                            resizeText(
                                              text:
                                                  "SeriesNumber: ${thumbnail.seriesList[index].headers["Series Number"] ?? "정보없음"}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            resizeText(
                                              text:
                                                  "환자명: ${thumbnail.seriesList[index].headers["Patient's Name"] ?? "정보없음"}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                            resizeText(
                                              text:
                                                  "환자나이: ${calculateAge(thumbnail.seriesList[index].headers["Patient's Birth Date"] ?? "정보없음")}",
                                              thumbnail: thumbnail,
                                              context: context,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.red)),
                                          child: CachedNetworkImage(
                                            imageUrl: thumbnail.getThumbnailUrl(
                                              index: index,
                                            ),
                                            // width: MediaQuery.of(context).size.width * 1.0,
                                            // height: 200,
                                            httpHeaders: {
                                              'accept': 'application/json',
                                              'Authorization':
                                                  "Bearer ${thumbnail.token}",
                                            },
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "\n시리즈 갯수 : ${thumbnail.seriesList.length}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  calculateAge(String birthDate) {
    // birthDate ?? null체크하기
    // 현재 날짜
    if (birthDate == "" || birthDate == 'UNKNOWN' || birthDate.isEmpty) {
      return "정보없음";
    } else {
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
    }
  }

  /// 그리드뷰의 행 갯수에따른 텍스트 사이즈 조절 함수
  resizeText(
      {required String text,
      required Thumbnail thumbnail,
      required BuildContext context}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: thumbnail.collectionValue.value == 1
            ? 14
            : thumbnail.collectionValue.value == 2
                ? 9
                : 5.8,
                color: Colors.white,
      ),
    );
  }
}
