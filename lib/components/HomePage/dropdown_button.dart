import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

dropDownButton({
  required BuildContext context, 
  required HomePageController homePageController
  }){
    return Obx(
      () => DropdownButton(
        value: homePageController.selectedValue.value,
        items:  homePageController.valueList.map(
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
        onChanged: (value) {
          homePageController.selectedValue.value = value!;
          homePageController.selectedFilter.value = value;
          if (value == '검사 일시') {
            showDialog(
              context: context, 
              builder: (context) => const HomePageDialog(),
            );
          } else {
            homePageController.searchTextController.text = '';
          }
        },
      ),
    );
}