import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_dialog_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDialog extends StatelessWidget {
  const HomePageDialog({super.key});

  @override
  Widget build(BuildContext context) {
  HomePageController homepageController = Get.find<HomePageController>();
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      title: const Text("검사 일시 검색"),
      content: SizedBox(
        width: 500,
        height: 490,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 달력
            homePageDialogCalendar(context: context, homePageController: homepageController),
            // 검사일자선택
            const Text(
              "검사 일자 선택",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            // 선택한 날짜 보여주기
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("\n\n"),
                Obx(()
                => Text(
                    homepageController.getSelectedRangeDate(),
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                homepageController.rangeStartDay.value = DateTime.now();
                homepageController.rangeEndDay.value = DateTime.now();
                homepageController.focusedDay.value = DateTime.now();
                homepageController.selectedValue.value = '환자 이름';
                homepageController.selectedFilter.value = '환자 이름';
                Get.back();
              }, 
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                // 홈페이지 컨트롤러의 선택된 날짜에 값 넣어야함
                Get.back();
                homepageController.searchTextController.text = homepageController.getSelectedRangeDate();
                homepageController.getFilteredData();
              }, 
              child: const Text("검색"),
            ),
          ],
        )
      ],
    );
  }
}