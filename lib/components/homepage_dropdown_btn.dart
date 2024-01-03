import 'package:flutter/material.dart';

class HomePageDropDownBtn extends StatefulWidget {
  const HomePageDropDownBtn({super.key});

  @override
  State<HomePageDropDownBtn> createState() => _HomePageDropDownBtnState();
}

class _HomePageDropDownBtnState extends State<HomePageDropDownBtn> {
  // property
  late List<String>  valueList;
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    valueList = ['환자 이름', '검사 장비', '검사 설명', '검사 일시', '판독 상태'];
    selectedValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text(
        valueList[selectedValue],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary
        ),
      ),
      disabledHint: const Text("검색 필터를 선택하세요"),
      items: valueList.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }
      ).toList(), 
      onChanged: (value) {
        selectedValue = value as int;
        print("${valueList[selectedValue]}");
        setState(() {
          
        });
      },
    );
  }
}