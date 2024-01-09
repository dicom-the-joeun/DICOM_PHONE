import 'package:dicom_phone/Model/homepage_table_data.dart';
import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_patient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePageDataTable extends StatefulWidget {
  const HomePageDataTable({super.key});

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
      height: 700,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() => DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(
                label: Text(
                  '환자 이름',
                  textAlign: TextAlign.center,
                ),
              ),
              DataColumn(
                label: Text(
                  '검사 장비',
                  textAlign: TextAlign.center,
                ),
              ),  
              DataColumn(
                label: Text(
                  '검사 일시',
                  textAlign: TextAlign.center,
                ),
              ),
            ], 
            rows: List.generate(homepageController.pacsData.length, (index) {
              HomePageTableData homePageData = homepageController.homePageData[index];
              return DataRow(
                cells: [
                  DataCell(
                    Text(homePageData.pName),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) => HomePagePatientDialog(studyKey: index),
                      );
                    },
                  ),
                  DataCell(
                    Text(homePageData.modallity),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) => HomePagePatientDialog(studyKey: index),
                      );
                    },
                  ),
                  DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(homePageData.studyDate.toString()))),
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) => HomePagePatientDialog(studyKey: index),
                      );
                    },
                  ),
                ],
                
              );
            }),
          ),
        ),
      ),
    );
  }
}