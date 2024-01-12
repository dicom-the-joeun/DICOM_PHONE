import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageSearchBar extends StatefulWidget {
  const HomePageSearchBar({super.key});

  @override
  State<HomePageSearchBar> createState() => _HomePageSearchBarState();
}

class _HomePageSearchBarState extends State<HomePageSearchBar> {
  // property
  late TextEditingController searchBarEditingController;

  HomePageController homeController = Get.find<HomePageController>();

  @override
  void initState() {
    super.initState();
    searchBarEditingController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 50,
      child: SearchBar(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.secondaryContainer
        ),
        controller: searchBarEditingController,
        trailing: [IconButton(
          onPressed: () {
            homeController.searchText.value = searchBarEditingController.text.trim();
            print("서치바 텍스트(icon) : ${homeController.searchText.value}");
            print("현재 선택된 필터 : ${homeController.selectedFilter.value}");
            homeController.getFilteredData();
            setState(() {
              
            });
          }, 
          icon: const Icon(Icons.search)
        )],
        shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
          )
        ),
        onSubmitted: (value) {
          // 키보드 엔터 쳤을 때
          homeController.searchText.value = searchBarEditingController.text.trim();
          print("서치바 텍스트(키보드) : ${homeController.searchText.value}");
          print("현재 선택된 필터 : ${homeController.selectedFilter.value}");
          homeController.getFilteredData();
          setState(() {
            
          });
        },
      ),
    );
  }
}