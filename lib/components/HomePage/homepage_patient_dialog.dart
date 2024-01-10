import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:dicom_phone/Repository/thumbnails.dart';
import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/View/series_listview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePagePatientDialog extends StatelessWidget {
  final int studyKey;
  const HomePagePatientDialog({super.key, required this.studyKey});

  /// 선택한 검사 상세 정보 페이지 (해당 검사의 모든 데이터 다 보여주기)
  @override
  Widget build(BuildContext context) {
    HomePageController homepageController = Get.find<HomePageController>();
    final Thumbnail thumbnail = Get.put(Thumbnail());
    // HomePageTableData homePageDetailData = homepageController.showStudyDetail(studyKey+1);
    HomePageTableData homePageData = homepageController.homePageData[studyKey];
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text("Previous"),
              SizedBox(
                // // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                      label: Text(
                        "",
                        // style: TextStyle(
                        //   fontSize: 16
                        // ),
          
                      ),
                    ),
                    DataColumn(
                      label: Text(""),
                    ),
                  ], 
                  rows:  [
                    DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 70,
                            child: Text("환자 아이디")
                          )
                        ),
                        DataCell(Text(homePageData.pId,))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("환자 이름")),
                        DataCell(Text(homePageData.pName))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("검사 일시")),
                        DataCell(Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(homePageData.studyDate.toString()))))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("검사 장비")),
                        DataCell(Text(homePageData.modallity))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("검사 설명")),
                        DataCell(
                          // Text(
                          //   homePageData.studyDescription ?? '-'
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              homePageData.studyDescription ?? '-'
                            ),
                          ),
                        )
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("판독 상태")),
                        DataCell(Text(homePageData.reportStatus==6? '판독' : homePageData.reportStatus==3? '읽지 않음' : '예비 판독'))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("시리즈")),
                        DataCell(Text(homePageData.seriesCount.toString()))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("이미지")),
                        DataCell(Text(homePageData.imageCount.toString()))
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Verify")),
                        DataCell(Text(homePageData.examStatus==1? '아니오' : '예'))
                      ],
                    ),
                  ]
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  thumbnail.getThumbnail(studyKey);
                  Get.to(() => const SireisListviewPage(), arguments: homePageData.studyKey);
                }, 
                child: const Text("상세 이미지 보기"),
              ),
              // Text("\nReport"),
              
            ],
          ),
        ),
      ),
    );
  }
}