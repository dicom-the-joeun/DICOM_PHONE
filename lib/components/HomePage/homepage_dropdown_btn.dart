import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDropDownBtn extends StatefulWidget {
  const HomePageDropDownBtn({super.key});

  @override
  State<HomePageDropDownBtn> createState() => _HomePageDropDownBtnState();
}

class _HomePageDropDownBtnState extends State<HomePageDropDownBtn> {
  @override
  Widget build(BuildContext context) {
    // property
    final List<String>  valueList = ['환자 이름', '검사 장비', '판독 상태'];
    String selectedValue = valueList[0];

    HomePageController homeController = HomePageController();

    return 
      DropdownButton(
        iconEnabledColor: Theme.of(context).colorScheme.primary,
        hint: Text(
          "검색 필터",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary
          ),
        ),
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: valueList.map(
          (String valueList) {
            return DropdownMenuItem(
              value: valueList,
              child: Text(
                valueList,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15
                ),
              ),
            );
          }
        ).toList(), 
        onChanged: (String? newValue) {
          selectedValue = newValue!;
          // print("$selectedValue");
          homeController.selectedFilter.value = selectedValue;
          print("검색 필터 : ${homeController.selectedFilter.value}");
          setState(() {
            
          });
        },
      );
  }
}