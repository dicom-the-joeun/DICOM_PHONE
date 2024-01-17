import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/components/HomePage/homepage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageSelectDate extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const HomePageSelectDate({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
          child: Text(
            "검사 일시 검색",
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
                builder: (context) => const HomePageDialog(),
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
              // 어제 ~ 오늘 데이터 보여주기
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
              Get.offAll(
                HomePage(onChangeTheme: onChangeTheme),
                transition: Transition.noTransition
              );
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
                "초기화",
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