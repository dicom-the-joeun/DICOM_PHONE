import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;
  late List<String> fruitList;
  bool allowZoom = false;
  bool bllowZoom = false;
  bool cllowZoom = false;
  double Brightness = 1.0;

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
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),    
          );
          
          allowZoom = _currentIndex == 4; // 4번째 탭만 확대/축소
          bllowZoom = _currentIndex == 5; // 5번째 탭만 화면전환
          return SizedBox(
            height: 100, // 이미지 크기
            child: _findex(index, allowZoom, bllowZoom, cllowZoom),
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
            label: '윈도우레벨',
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
            label: '확대/축소',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flip),
            label: '수평반전',
          ),
        ],
        selectedItemColor: Colors.red,
      ),
    );
  }

  Widget _findex(int index, bool allowZoom, bool bllowZoom, bool cllowZoom) {
     return Transform(
      alignment: Alignment.center,
      transform: bllowZoom
          ? Matrix4.rotationY(math.pi) // 5번째 탭일 때 좌우반전
          : Matrix4.identity(),
          
   
      child: PhotoView(
        imageProvider: AssetImage('images/${fruitList[index]}'),
        minScale: allowZoom //최소 축소 비율
            ? PhotoViewComputedScale.contained * 0.8 //true 일 때
            : PhotoViewComputedScale.contained, // false 일 때
        maxScale: allowZoom //최소 확대 비율
            ? PhotoViewComputedScale.covered * 1.8 //true 일 때
            : PhotoViewComputedScale.contained, // false 일 때
      ),
    );
  }
}
