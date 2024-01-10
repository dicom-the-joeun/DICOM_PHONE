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
      child: Obx(() => DataTable2(
          showCheckboxColumn: false,
          columnSpacing: 20,
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
          ], 
          rows: List.generate(homepageController.homePageData.length, (index) {
            HomePageTableData homePageData = homepageController.homePageData[index];
            return DataRow(
              onSelectChanged: (value) {
                showDialog(
                  context: context, 
                  builder: (context) => HomePagePatientDialog(studyKey: index, onChangeTheme: widget.onChangeTheme),
                );
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
              ],
              
            );
          }),
        ),
      ),
    );
  }
}