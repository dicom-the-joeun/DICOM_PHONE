import 'package:dicom_phone/components/homepage_calendar.dart';
import 'package:dicom_phone/components/homepage_dropdown_btn.dart';
import 'package:dicom_phone/components/homepage_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    onPressed: () {
                      Get.to(const HomePageCalendar());
                    }, 
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: HomePageDropDownBtn(),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: HomePageSearchBar(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}