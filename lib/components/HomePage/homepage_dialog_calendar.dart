import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

homePageDialogCalendar({required BuildContext context, required HomePageController homePageController}) {
  
  return SizedBox(
      height: 400,
      child: Obx(() => 
        TableCalendar(
          focusedDay: homePageController.focusedDay.value,             // 달력에서 선택된 날짜
          firstDay: DateTime.utc(1900, 1, 1),     // 전체 달력 시작 날짜
          lastDay: DateTime.utc(3000, 12, 31),    // 전체 달력 끝 날짜
          locale: 'ko_KR',                        // 언어 설정
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,            
          ),
          calendarStyle: CalendarStyle(
            rangeHighlightColor: Theme.of(context).colorScheme.tertiaryContainer,
            rangeStartDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle
            ),
            rangeEndDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle
            ),
            weekendTextStyle: const TextStyle(color: Colors.red),
          ),
          // daysOfWeekVisible: true,
          rangeStartDay: homePageController.rangeStartDay.value,
          rangeEndDay: homePageController.rangeEndDay.value,
          onRangeSelected: homePageController.onRangeSelected,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
      )
    );
}