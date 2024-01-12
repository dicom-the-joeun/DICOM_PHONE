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
    // ignore: deprecated_member_use
    return WillPopScope( // 슬라이드로 뒤로가기 막기
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: MyAppbar(onChangeTheme: onChangeTheme, backStatus: false),
        body: SingleChildScrollView(
          child: Column(
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
              Obx(() => Text(
                "\n총 검사 건수 : ${homepageController.filteredData.length}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}