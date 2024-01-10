import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/View/myappbar.dart';
import 'package:dicom_phone/components/HomePage/homepage_data_table.dart';
import 'package:dicom_phone/components/HomePage/homepage_dropdown_btn.dart';
import 'package:dicom_phone/components/HomePage/homepage_searchbar.dart';
import 'package:dicom_phone/components/HomePage/homepage_select_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const HomePage({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    HomePageController homepageController = Get.put(HomePageController());
    return Scaffold(
      appBar: MyAppbar(onChangeTheme: onChangeTheme, backStatus: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: HomePageDropDownBtn(),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: HomePageSearchBar(),
              ),
            ],
          ),
          const HomePageSelectDate(),
          HomePageDataTable(onChangeTheme: onChangeTheme),
          // DataTable(
          //   columnSpacing: 10,
          //   columns: const [
          //     DataColumn(
          //       label: Text(
          //         '환자 이름'
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         '검사 장비'
          //       ),
          //     ),
          //     // DataColumn(
          //     //   label: Text(
          //     //     '검사 설명'
          //     //   ),
          //     // ),
          //     DataColumn(
          //       label: Text(
          //         '검사 일시'
          //       ),
          //     ),
          //   ], 
          //   rows: List.generate(homepageController.pacsData.length, (index) {
          //     HomePageTableData homePageData = homepageController.homePageData[index];
          //     return DataRow(
          //       cells: [
          //         DataCell(Text(homePageData.pName)),
          //         DataCell(Text(homePageData.modallity)),
          //         // DataCell(Text(homePageData.studyDescription ?? '-')),
          //         DataCell(Text(homePageData.studyDate.toString())),
          //         // DataCell(Text(homePageData.examStatus == 1? '아니오' : '예')),
          //       ],
          //     );
          //   }),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     homepageController.getJSONData();
          //   }, 
          //   child: Text('json test'))
        ],
      ),
    );
  }
}