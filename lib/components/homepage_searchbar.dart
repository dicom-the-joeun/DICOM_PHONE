import 'package:flutter/material.dart';

class HomePageSearchBar extends StatefulWidget {
  const HomePageSearchBar({super.key});

  @override
  State<HomePageSearchBar> createState() => _HomePageSearchBarState();
}

class _HomePageSearchBarState extends State<HomePageSearchBar> {
  // property
  late TextEditingController searchBarEditingController;

  @override
  void initState() {
    super.initState();
    searchBarEditingController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 50,
      child: SearchBar(
        // backgroundColor: ,
        controller: searchBarEditingController,
        // elevation: ,
        trailing: const [Icon(Icons.search)],
        shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        )),
      ),
    );
  }
}