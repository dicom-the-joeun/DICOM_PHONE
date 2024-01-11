import 'package:data_table_2/data_table_2.dart';
import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_patient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePageDataTable extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const HomePageDataTable({super.key, required this.onChangeTheme});

  @override
  State<HomePageDataTable> createState() => _HomePageDataTableState();
}

class _HomePageDataTableState extends State<HomePageDataTable> {
  HomePageController homepageController = Get.find<HomePageController>();
  // HomePageController homepageController = Get.put(HomePageController());

  @override
  void initState() {
    homepageController.getJSONData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Obx(() => DataTable2(
          showCheckboxColumn: false,
          columnSpacing: 5,
          columns: const [
            DataColumn2(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '환자 이름',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            DataColumn2(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '검사 장비',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ), 
            DataColumn2(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '검사 일시',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            DataColumn2(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '판독 상태',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ], 
          rows: List.generate(homepageController.homePageData.length, (index) {
            HomePageTableData homePageData = homepageController.homePageData[index];
            return DataRow(
              onSelectChanged: (value) {
                showDialog(
                  context: context, 
                  builder: (context) => HomePagePatientDialog(studyKey: homePageData.studyKey, index: index, onChangeTheme: widget.onChangeTheme),
                );
                print("study key : ${homePageData.studyKey}");
                // print('강감찬 환자의 데이터 : ${homePageData.where().toList()}');
              },
              cells: [
                DataCell(
                  Text(homePageData.pName),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(homePageData.modallity),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(homePageData.studyDate.toString()))),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(homePageData.reportStatus==6? '판독' : homePageData.reportStatus==3? '읽지 않음' : '예비 판독'),
                    ],
                  ),
                ),
              ],
              
            );
          }),
        ),
      ),
    );
  }
}