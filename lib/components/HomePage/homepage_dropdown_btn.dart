import 'package:dicom_phone/VM/homepage_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomePageDropDownBtn extends StatefulWidget {
  const HomePageDropDownBtn({super.key});

  @override
  State<HomePageDropDownBtn> createState() => _HomePageDropDownBtnState();
}

class _HomePageDropDownBtnState extends State<HomePageDropDownBtn> {
  // property
  late List<String>  valueList;
  late String? selectedValue;

  HomePageSearchController searchController = HomePageSearchController();

  @override
  void initState() {
    super.initState();
    valueList = ['환자 이름', '검사 장비', '판독 상태'];
    selectedValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
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
        searchController.selectedSearchFilter.value = selectedValue!;
        print("검색 컨트롤러의 선택된 필터 : ${searchController.selectedSearchFilter.value}");
        setState(() {
          
        });
      },
    );
  }
}