import 'dart:io';

import 'package:dicom_phone/VM/detail_image.dart';

import 'package:dicom_phone/View/myappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const DetailPage({super.key, required this.onChangeTheme});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DetailImageController detailImageController =
      Get.put(DetailImageController());
  late List<int> currentIndex;
  Set<int> selectedTabs = {}; // Set을 사용하여 다중 선택을 관리합니다.
  double windowLevelSlider = 0; // 밝기
  bool isAnimating = true;
  int animationSpeed = 300;
  double scrollLoopSlider = 0.0; //스크롤 루프
  double playClipSlider = 0.0; //플레이 클립
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = [0, 1, 2, 3, 4, 5];
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
  // 현재 선택된 밝기와 플레이 클립 값에 해당하는 이미지들을 구함
  List<String> imagesAtSelectedBrightnessAndClip = detailImageController.imagePathList
      .where((path) =>
          getWindowLevelFromFileName(path) == detailImageController.brightnessValue.value &&
          playClipSlider == 2.0) // 플레이 클립 값이 1.0인 경우에만 필터링
      .toList();

  Future.delayed(Duration(milliseconds: animationSpeed), () {
    if (isAnimating && imagesAtSelectedBrightnessAndClip.isNotEmpty) {
      // 현재 인덱스에서 시작하여 같은 밝기 및 플레이 클립 값의 이미지로만 애니메이션을 진행
      currentImageIndex = (currentImageIndex + 1) % imagesAtSelectedBrightnessAndClip.length;

      // 변경된 이미지 인덱스로 업데이트
      setState(() {});

      // 애니메이션을 계속 진행
      _animate();
    }
  });
}


  void setAnimationSpeed(int speed) {
    setState(() {
      animationSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        print("디테일 페이지 닫힘@@@@@@@@@");
        await detailImageController
            .deleteDirectoryFile(); // 페이지 나갈때 디렉토리에서 파일 삭제
      },
      child: Scaffold(
        appBar: MyAppbar(
          key: (UniqueKey()),
          onChangeTheme: widget.onChangeTheme,
          backStatus: true,
        ),
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
                  : _buildImage(currentImageIndex),
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
                            selectedTabs.contains(0) ? windowLevelSlider : scrollLoopSlider,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            if (selectedTabs.contains(0)) {
                              windowLevelSlider = detailImageController.sliderValue.value;
                              windowsLevel(value);
                            } else if (selectedTabs.contains(2)) {
                              scrollLoopSlider = detailImageController.sliderValue.value;
                              // detailImageController.changeImage(value);
                              changeImages(value);
                            }
                          });
                        },
                      )
                    : Container(),
              ),
            ),
            if (selectedTabs.contains(3))
              Positioned(
                bottom: MediaQuery.of(context).size.height / 50,
                left: MediaQuery.of(context).size.width / 2.5 - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: [
                          Slider(
                            value: animationSpeed.toDouble(),
                            min: 0,
                            max: 800,
                            onChanged: (value) {
                              setState(() {
                                setAnimationSpeed(value.toInt());
                              });
                            },
                          ),
                          Text(
                            'Animation Speed: $animationSpeed',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            startAnimation();
                          },
                          child: Text('시작'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            stopAnimation();
                          },
                          child: Text('중지'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
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
              label: '스크롤루프',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.slow_motion_video),
              label: '플레이클립',
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

    List<String> sortedImagePathList = getSortedImagePathList();

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
          
          imageProvider: FileImage(File(sortedImagePathList[index])),
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

  void windowsLevel(double value) {
    int index = (value * (detailImageController.imagePathList.length)).round();
    print('Changing image to index: $index');

    setState(() {
      currentImageIndex = index;
      windowLevelSlider = value;
      if (currentImageIndex == detailImageController.imagePathList.length - 1) {
        currentImageIndex = 0;
        windowLevelSlider = 0.0; // 슬라이더 값도 초기화
      }
    });
  }

   double getWindowLevelFromFileName(String fileName) {
    // 파일명에서 윈도우 레벨 값을 추출하여 반환
    List<String> parts = fileName.split('_');
    return double.tryParse(parts.last) ?? 0.0;
  }

  void changeImages(double value){

  }

void moveFileFromTo(List<String> list, int fromIndex, int toIndex) {
    if (fromIndex >= 0 && fromIndex < list.length && toIndex >= 0 && toIndex < list.length) {
      String removedFile = list.removeAt(fromIndex);
      list.insert(toIndex, removedFile);
    }
  }

  List<String> getSortedImagePathList() {
    List<String> sortedList = List.from(detailImageController.imagePathList);

    // 정렬 함수를 사용하여 파일명을 기준 숫자로 정렬
    sortedList.sort((a, b) {
      List<int> aNumbers = getNumbersFromFileName(a);
      List<int> bNumbers = getNumbersFromFileName(b);

      // 각 숫자를 비교하여 정렬
      for (int i = 0; i < aNumbers.length; i++) {
        int result = aNumbers[i].compareTo(bNumbers[i]);
        if (result != 0) {
          return result;
        }
      }

      return 0;
    });

    // 1번 인덱스의 파일을 10번 인덱스로 이동
    moveFileFromTo(sortedList, 1, 9);
    moveFileFromTo(sortedList, 11, 19);
    moveFileFromTo(sortedList, 21, 29);
    moveFileFromTo(sortedList, 31, 40);

    return sortedList;

    
  }

    List<int> getNumbersFromFileName(String fileName) {
    // 파일명에서 언더스코어로 분리된 부분을 추출하여 정수 리스트로 반환
    List<String> parts = fileName.split('_');
    List<int> numbers = parts.map((part) => int.tryParse(part) ?? 0).toList();
    return numbers;
  }

}
