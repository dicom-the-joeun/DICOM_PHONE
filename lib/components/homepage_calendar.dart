import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePageCalendar extends StatelessWidget {
  const HomePageCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TableCalendar(
          focusedDay: DateTime.now(),             // 달력에서 선택된 날짜
          firstDay: DateTime.utc(2000, 1, 1),     // 전체 달력 시작 날짜
          lastDay: DateTime.utc(3000, 12, 31),    // 전체 달력 끝 날짜
          locale: 'ko_KR',                        // 언어 설정
        ),
      ],
    );
  }
}