import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_dialog_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

homePageDialog({required BuildContext context}) {
  HomePageController homepageController = Get.find<HomePageController>();
  // DateTime? rangeStart =  homepageController.rangeStartDay.value;
  // DateTime? rangeEnd =  homepageController.rangeEndDay.value;
  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.onSecondary,
    title: const Text("검사 일자 검색"),
    content: SizedBox(
      width: 500,
      height: 490,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 달력
          // HomePageDialogCalendar(),
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
                Obx(() => Text(
                    homepageController.getSelectedRangeDate()
                  ),
                )
                // Text(
                //   // homepageController.rangeStartDay.value != null 
                //   // ? DateFormat('yyyy-MM-dd').format(homepageController.rangeStartDay.value!)
                //   // : "",
                //   homepageController.formatRangeDate(homepageController.rangeStartDay.value),
                //   style: const TextStyle(
                //     fontSize: 20
                //   ),
                // ),
                // Text(
                //   homepageController.rangeStartDay.value != null && homepageController.rangeEndDay.value != null 
                //   ? "   ~   " : "",
                //   style: const TextStyle(
                //     fontSize: 20
                //   ),
                // ),
                // Text(
                //   // homepageController.rangeEndDay.value != null
                //   // ? DateFormat('yyyy-MM-dd').format(homepageController.rangeEndDay.value!)
                //   // : "",
                //   homepageController.formatRangeDate(homepageController.rangeEndDay.value),
                //   style: const TextStyle(
                //     fontSize: 20
                //   ),
                // ),
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
              Get.back();
            }, 
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              
            }, 
            child: const Text("적용"),
          ),
        ],
      )
    ],
  );
}