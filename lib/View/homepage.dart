import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_dropdown_btn.dart';
import 'package:dicom_phone/components/HomePage/homepage_searchbar.dart';
import 'package:dicom_phone/components/HomePage/homepage_select_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homepageController = Get.put(HomePageController());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          // const HomePageSelectDate(),
          // DataTable(
          //   columns: const [
          //     // DataColumn(
          //     //   label: Text(
          //     //     '환자 아이디'
          //     //   ),
          //     // ),
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
          //     DataColumn(
          //       label: Text(
          //         '검사 설명'
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         '판독 상태'
          //       ),
          //     ),
          //   ], 
          //   rows: List.generate(homepageController.pacsData.length, (index) {
              
          //   }),
          // ),
          ElevatedButton(
            onPressed: () {
              homepageController.getJSONData();
            }, 
            child: Text('json test'))
        ],
      ),
    );
  }
}