import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;
  late List<String> fruitList;
  bool zoomin = false;

  @override
  void initState() {
    super.initState();
    fruitList = [
      'Apple.png',
      'Banana.png',
      'Grape.png',
      'Orange.png',
      'Pineapple.png',
      'Watermelon.png',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PACSPLUS3'),
        iconTheme: IconThemeData(color: Colors.red),
      ),
body: ListView.builder(
  itemCount: fruitList.length,
  itemBuilder: (context, index) {
    return SizedBox(
      height: 500, // 이미지 크기
      child: PhotoView(
        imageProvider: AssetImage('images/${fruitList[index]}'), // 이미지 인덱스 
        minScale: PhotoViewComputedScale.contained * 0.8 , // 축소 배율
        maxScale: PhotoViewComputedScale.covered *1.0, // 확대 배율
        enableRotation: true, 
        heroAttributes: PhotoViewHeroAttributes(tag: 'tag'),
      ),
    );
  },
),


      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_display_rounded),
              label: '윈도우라벨',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flip),
              label: '흑백반전',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swipe_sharp),
              label: '스크롤 루프',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.slow_motion_video),
              label: '플레이 클립',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.zoom_in),
              label: '확대',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.zoom_out),
              label: '축소',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flip),
              label: '수평반전',
            ),
          ],
          selectedItemColor: Colors.red),
    );
  }
}
