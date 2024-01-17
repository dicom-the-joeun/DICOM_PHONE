import 'dart:io';

import 'package:dicom_phone/Model/imagekey.dart';
import 'package:dicom_phone/VM/detail_image_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  // final Function(ThemeMode) onChangeTheme;
  const DetailPage({super.key, required this.onChangeTheme});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
   
  final DetailImageController detailImageController =
      Get.put(DetailImageController());
  late List<int> currentIndex;
  late List<String> fruitList;
  Set<int> selectedTabs = {}; // Set을 사용하여 다중 선택을 관리합니다.
  double brightness = 0;
  bool isAnimating = true;

  double sliderValue = 0.5;
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
    isAnimating = true;
    _animate();
  }

  void _animate() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (isAnimating) {
        setState(() {
          currentImageIndex = (currentImageIndex + 1) % detailImageController.imagePathList.length;
         if (currentImageIndex == detailImageController.imagePathList.length - 1) {
            currentImageIndex = 0;
          }
        });
        print(currentImageIndex);
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        print("디테일 페이지 닫힘@@@@@@@@@");
        ImageKey.studyKey = 0;
        ImageKey.seriesKey = 0;
        await detailImageController
            .deleteDirectoryFile(); // 페이지 나갈때 디렉토리에서 파일 삭제
             
      },
      child: Scaffold(
        // appBar: MyAppbar(
        //   onChangeTheme: onChangeTheme,
        //     backStatus: true,
        // ),
        body: Stack(
          children: [
            Obx(
              () => detailImageController.imagePathList.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("이미지 불러오는중 ...")
                      ],
                    )
                  : ListView.builder(
                      itemCount: detailImageController.imagePathList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width,
                          child: _buildImage(index), 
                          
                        );
                      },
                    ),
            ),
            Positioned(
              top: 150,
              right: 0,
              child: RotatedBox(
                quarterTurns: 1,
                child: selectedTabs.contains(0) ||
                        selectedTabs.contains(2) // 0번 또는 2번 탭에서 슬라이더 표시
                    ? CupertinoSlider(
                      
                        value:
                            selectedTabs.contains(0) ? brightness : sliderValue,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            if (selectedTabs.contains(0)) {
                              brightness = value;
                            } else if (selectedTabs.contains(2)) {
                              sliderValue = detailImageController.sliderValue.value;
                              // detailImageController.changeImage(value);
                              changeImages(value);
                            }
                              Transform(transform: Matrix4.rotationY(math.pi));
                          });
                        },
                      )
                    : Container(),
              ),
            ),
            if (selectedTabs.contains(3))
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
      ),
    );
  }

  Widget _buildImage(int index) {
    bool allowZoom = selectedTabs.contains(4); // 확대/축소 탭
    bool bllowZoom = selectedTabs.contains(5); // 화면전환 탭

    return ColorFiltered(
      colorFilter: selectedTabs.contains(1)
          ? const ColorFilter.mode(
              Colors.grey,
              BlendMode.difference,
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
          
          imageProvider: FileImage(File(detailImageController.imagePathList[currentImageIndex]))
,
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

void changeImages(double value) {
  int index = (value * (detailImageController.imagePathList.length - 1 )).round();
  print('Changing image to index: $index');
 
 setState(() {
   
    currentImageIndex = index;
    sliderValue = value;
 if (currentImageIndex == detailImageController.imagePathList.length - 1) {
        currentImageIndex = 0;
        sliderValue = 0.0; // 슬라이더 값도 초기화
      }
 });
  
}

}

