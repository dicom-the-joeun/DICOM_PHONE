import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:flutter/material.dart';

homePageSearchBar({required BuildContext context, required HomePageController homePageController}) {
  return SizedBox(
    width: 280,
    height: 50,
    child: SearchBar(
      backgroundColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.secondaryContainer
      ),
      controller: homePageController.searchTextController,
      trailing: [IconButton(
        onPressed: () {
          homePageController.getFilteredData();
        }, 
        icon: const Icon(Icons.search)
      )],
      shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))
        )
      ),
      onSubmitted: (value) {
        // 키보드 엔터 쳤을 때
        homePageController.getFilteredData();
      },
    ),
  );
}