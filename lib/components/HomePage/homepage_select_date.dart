import 'package:dicom_phone/components/HomePage/homepage_dialog.dart';
import 'package:flutter/material.dart';

class HomePageSelectDate extends StatelessWidget {
  const HomePageSelectDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
          child: Text(
            "검사 일자 선택",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context, 
                // builder: (context) => homePageDialog(context: context),
                builder: (context) => HomePageDialog(),
              );
            }, 
            icon: Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: GestureDetector(
            onTap: () {
              // 오늘자 데이터 보여주기
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary
              ),
              alignment: Alignment.center,
              child: Text(
                "1일",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: GestureDetector(
            onTap: () {
              // (3일 전 ~ 오늘) 데이터 보여주기
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              alignment: Alignment.center,
              child: Text(
                "3일",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: GestureDetector(
            onTap: () {
              // 1주일 전 ~ 오늘 데이터 보여주기
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary
              ),
              alignment: Alignment.center,
              child: Text(
                "1주일",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: GestureDetector(
            onTap: () {
              // 검색 필터, 검색 일자 모두 reset 하기
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary
              ),
              alignment: Alignment.center,
              child: Text(
                "재설정",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}