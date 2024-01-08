import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;
  late List<String> fruitList;
  bool allowZoom = false;
  bool bllowZoom = false;
  bool cllowZoom = false;
  bool dllowZoom = false;
  double brightness = 0; //
  bool isImageColored = true;

   void _toggleImageColor() {
    setState(() {
      isImageColored = !isImageColored;
    });
  }

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
      body: Stack(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fruitList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 230, // 이미지 크기
                  child: Stack(
                    children: [
                      _findex(index),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_currentIndex == 0) // 0번째 탭에서만 슬라이더 표시
            Positioned(
              top: 150, // slider 오른쪽 화면 중앙에 배치
              right: 0, // slider 오른쪽 화면에 배치
              child: RotatedBox(
                quarterTurns: 1,
                child: Slider(
                  value: brightness, 
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      brightness = value;
                    });
                  },
                ),
              ),
            ),
        ],
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

  Widget _findex(int index) {
    cllowZoom = _currentIndex == 0;
    dllowZoom = _currentIndex == 1;
    allowZoom = _currentIndex == 4; // 4번째 탭만 확대/축소
    bllowZoom = _currentIndex == 5; // 5번째 탭만 화면전환

      return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(1 - brightness),
            BlendMode.modulate,
          ),
          child: Transform(
            alignment: Alignment.center,
            transform: bllowZoom
                ? Matrix4.rotationY(math.pi) // 5번째 탭일 때 좌우반전
                : Matrix4.identity(),
            child: GestureDetector(
              onTap: dllowZoom ? _toggleImageColor : null,
              child: PhotoView(
                imageProvider: AssetImage('images/${fruitList[index]}'),
                minScale: allowZoom
                    ? PhotoViewComputedScale.contained * 0.8
                    : PhotoViewComputedScale.contained,
                maxScale: allowZoom
                    ? PhotoViewComputedScale.covered * 1.8
                    : PhotoViewComputedScale.contained,
              ),
            ),
          ),
        ),
        if (_currentIndex == 1)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: ColorFiltered(
                colorFilter: isImageColored
                    ? ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.saturation,
                      )
                    : ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                child: Image.asset(
                  'images/${fruitList[index]}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    );
  }
}