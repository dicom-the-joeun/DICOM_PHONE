import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_dialog_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDialog extends StatelessWidget {
  const HomePageDialog({super.key});


  @override
  Widget build(BuildContext context) {
    // property
    // String rangeStartDay = Message.rangeStartDay.toString() ?? "";
    // String rangeEndDay = Message.rangeEndDay.toString() ?? "";
    final dialogController = Get.find<HomePageController>();
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: const Text("검사 일자 검색"),
      content: SizedBox(
        width: 500,
        height: 490,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 달력
            HomePageDialogCalendar(),
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
                  Text(
                    dialogController.formatRangeDate(dialogController.rangeStartDay.value),
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const Text(
                    "   ~   ",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Text(
                    dialogController.formatRangeDate(dialogController.rangeEndDay.value),
                    style: const TextStyle(
                      fontSize: 20
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
}