import 'package:flutter/material.dart';

class HomePageCalendar extends StatelessWidget {
  const HomePageCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('달력 모달로 띄우기',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }
}