import 'package:dicom_phone/View/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget  {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        width: 45,
        height: 45,
        child: Image.asset("images/pacs.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const MyDrawer());
            },
            icon: const Icon(Icons.menu),
            ),
        ],
    );
  }

    @override
  // preferredSize 지정
  Size get preferredSize => const Size.fromHeight(56);

}