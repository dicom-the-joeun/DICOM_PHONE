import 'package:flutter/material.dart';

class HomePageDropDownBtn extends StatefulWidget {
  const HomePageDropDownBtn({super.key});

  @override
  State<HomePageDropDownBtn> createState() => _HomePageDropDownBtnState();
}

class _HomePageDropDownBtnState extends State<HomePageDropDownBtn> {
  // property
  late List<String>  valueList;
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    valueList = ['환자 이름', '검사 장비', '검사 설명', '검사 일시', '판독 상태'];
    selectedValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconEnabledColor: Theme.of(context).colorScheme.primaryContainer,
      dropdownColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.primaryContainer,
      hint: Text(
        "검색 필터",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer
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
                color: Theme.of(context).colorScheme.primaryContainer,
                fontSize: 15
              ),
            ),
          );
        }
      ).toList(), 
      onChanged: (String? newValue) {
        selectedValue = newValue!;
        print("$selectedValue");
        setState(() {
          
        });
      },
    );
  }
}