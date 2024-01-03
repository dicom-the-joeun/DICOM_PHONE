import 'package:dicom_phone/thirdpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PACSPLUS2'),
        iconTheme: IconThemeData(
          color: Colors.red
        ),
      ),
      body: Center(
        child: Column(
          children: [           
            ElevatedButton(
              onPressed: (){
                Get.to(DetailPage());
              },
              child: Text('상세페이지 이동'))
          ],
        ),
      ),
    );
    
  }
}