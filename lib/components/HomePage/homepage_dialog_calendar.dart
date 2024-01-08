import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePageDialogCalendar extends StatelessWidget {
  HomePageDialogCalendar({super.key});
  final dialogController = Get.find<HomePageController>();

  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Obx(() => 
        TableCalendar(
          focusedDay: dialogController.focusedDay.value,             // 달력에서 선택된 날짜
          firstDay: DateTime.utc(2000, 1, 1),     // 전체 달력 시작 날짜
          lastDay: DateTime.utc(3000, 12, 31),    // 전체 달력 끝 날짜
          locale: 'ko_KR',                        // 언어 설정
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true
          ),
          // calendarStyle: CalendarStyle(
          //   rangeHighlightColor: Theme.of(context).colorScheme.primaryContainer,
          //   rangeStartDecoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          //   rangeEndDecoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary,
          //   )
          // ),
          rangeStartDay: dialogController.rangeStartDay.value,
          rangeEndDay: dialogController.rangeEndDay.value,
          onRangeSelected: dialogController.onRangeSelected,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
      )
    );
  }
}