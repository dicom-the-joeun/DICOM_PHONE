import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<int> currentIndex;
  late List<String> fruitList;
  Set<int> selectedTabs = {}; // Set을 사용하여 다중 선택을 관리합니다.
  double brightness = 0;
  bool isAnimating = true;

  double sliderValue = 0.0;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = [0, 1, 2, 3, 4, 5];
    fruitList = [
      'Apple.png',
      'Banana.png',
      'Grape.png',
      'Orange.png',
      'Pineapple.png',
      'Watermelon.png',
    ];
    

  }

void stopAnimation() {
  setState(() {
    isAnimating = false;
  });
}

void startAnimation() {
  isAnimating = true; // 여기서 isAnimating을 다시 true로 설정
  _animate();
}

void _animate() {
  Future.delayed(Duration(milliseconds: 200), () {
    if (isAnimating) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % fruitList.length;
      });
      _animate();
    }
  });
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
                  height: 230,
                  child: Stack(
                    children: [
                      _buildImage(index),
                    ],
                  ),
                );
              },
            ),
          ),
            if(selectedTabs.contains(3))
           Positioned(
              top: 150,
              right: 0,
              child: RotatedBox(
                quarterTurns: 1,
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                       
                        startAnimation();
                       
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Animation'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        stopAnimation();
                      },
                      icon: Icon(Icons.stop),
                      label: Text('Stop Animation'),
                    ),
                  ],
                ),
              ),
            ),
          if(selectedTabs.contains(3))
         Positioned(
            top: 150,
            right: 0,
            child: RotatedBox(
              quarterTurns: 1,
                   child: selectedTabs.contains(0) // 1번 탭에서만 슬라이더 표시
        ? Slider(
            value: brightness,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {
              setState(() {
                brightness = value;
              });
            },
          )
        : selectedTabs.contains(2) // 2번 탭에서만 슬라이더 표시
            ? Slider(
                value: sliderValue,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    changeImage(value);
                  });
                },
              )
    : Container(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTabs.isNotEmpty ? selectedTabs.first : 0,
        onTap: (index) {

          setState(() {

            if (selectedTabs.contains(index)) {
              selectedTabs.remove(index);
            } else {
              selectedTabs.add(index);
            }
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
),
      backgroundColor: Colors.red,
    );
  }

  Widget _buildImage(int index) {
    bool allowZoom = selectedTabs.contains(4); // 확대/축소 탭
    bool bllowZoom = selectedTabs.contains(5); // 화면전환 탭

    return ColorFiltered(
      colorFilter: selectedTabs.contains(1)
          ? const ColorFilter.mode(
              Colors.grey,
              BlendMode.color,
            )
          : const ColorFilter.mode(
              Colors.transparent,
              BlendMode.saturation,
            ),
        child: Transform(
          alignment: Alignment.center,
          transform: bllowZoom
              ? Matrix4.rotationY(math.pi) // 5번째 탭일 때 좌우반전
              : Matrix4.identity(),
          child: PhotoView(
            imageProvider: AssetImage('images/${fruitList[currentImageIndex]}'),
            minScale: allowZoom
                ? PhotoViewComputedScale.contained * 0.8
                : PhotoViewComputedScale.contained,
            maxScale: allowZoom
                ? PhotoViewComputedScale.covered * 1.8
                : PhotoViewComputedScale.contained,
          ),
        ),
      
    );
  }

  void changeImage(double value) {
    // Calculate the index based on the slider value
    int index = (value * (fruitList.length - 1)).round();

    // Update the currentImageIndex
    setState(() {
      currentImageIndex = index;
      sliderValue = value;
    });
  }
}
