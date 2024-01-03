import 'package:dicom_phone/View/homepage.dart';
import 'package:dicom_phone/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
// aas
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PACSPLUS'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(SecondPage());
              }, 
              child: const Text("두번째 페이지 이동"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const HomePage());
              }, 
              child: const Text("홈페이지 이동"),
            ),
          ],
        ),
      ),
    );
  }
}