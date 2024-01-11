import 'package:dicom_phone/VM/homepage_search_controller.dart';
import 'package:flutter/material.dart';

class HomePageSearchBar extends StatefulWidget {
  const HomePageSearchBar({super.key});

  @override
  State<HomePageSearchBar> createState() => _HomePageSearchBarState();
}

class _HomePageSearchBarState extends State<HomePageSearchBar> {
  // property
  late TextEditingController searchBarEditingController;

  HomePageSearchController searchController = HomePageSearchController();

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
            searchController.searchBarText.value = searchBarEditingController.text;
            print("검색 컨트롤러의 서치바 텍스트 : ${searchController.searchBarText.value}");
            searchController.getFilteredData(searchController.selectedSearchFilter.value, searchController.searchBarText.value);
          }, 
          icon: const Icon(Icons.search)
        )],
        shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
          )
        ),
        onSubmitted: (value) {
          // 키보드 엔터 쳤을 때
          searchController.searchBarText.value = searchBarEditingController.text;
          print("검색 컨트롤러의 서치바 텍스트 : ${searchController.searchBarText.value}");
          searchController.getFilteredData(searchController.selectedSearchFilter.value, searchController.searchBarText.value);
        },
      ),
    );
  }
}