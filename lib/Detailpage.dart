import 'dart:io';
import 'package:dicom_phone/Model/detailpage_model.dart';
import 'package:dicom_phone/Model/imagekey.dart';
import 'package:dicom_phone/Model/thubmnail_model.dart';
import 'package:dicom_phone/VM/detail_image_ctrl.dart';
import 'package:dicom_phone/View/myappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  final ThumbnailModel thumbnailModel;
  const DetailPage({
    super.key,
    required this.onChangeTheme,
    required this.thumbnailModel,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

int imageIndex = 1;
int windowIndex = 1;

class _DetailPageState extends State<DetailPage> {
 
  late ThumbnailModel currentSeries;
  DetailImageController detailImageController = Get.put(DetailImageController());


  bool isAnimating = true;
  late List<int> currentIndex;
  Set<int> selectedTabs = {}; // Set을 사용하여 다중 선택을 관리합니다.
  int animationSpeed = 300; // 플레이 클립 재생 값
  int currentImageIndex = 0; // 이미지 값
  double playClipSlider = 0.0; //플레이 클립
  double scrollLoopSlider = 1.0; //스크롤 루프
  double windowLevelSlider = 1.0; // 밝기

  @override
  void initState() {
    super.initState();
    currentIndex = [0, 1, 2, 3, 4];
    currentSeries = widget.thumbnailModel;
    imageIndex = 1;
    windowIndex = 1;
   

  }

  void stopAnimation() {
    setState(() {
      isAnimating = false;
      print(isAnimating);
    });
  }

  void startAnimation() {
    isAnimating = true;
    playClip(playClipSlider);
  }

  void setAnimationSpeed(int speed) {
    setState(() {
      animationSpeed = speed;
    });
  }

void playClip(double value) async {
  while (isAnimating && mounted) {
    await Future.delayed(Duration(milliseconds: animationSpeed.toInt()));
    if (!isAnimating || !mounted) {
      break; // 종료 조건
    }

    setState(() {
      currentImageIndex = (currentImageIndex + 1) %
          detailImageController.imagePathList.length;
      if (currentImageIndex ==
          detailImageController.imagePathList.length - 1) {
        currentImageIndex = 0;
      }
      imageIndex = currentImageIndex + 1;
    });

    // 이미지 파일이 존재하는지 확인
    String imagePath = '${detailImageController.destinationDirectory.value}/'
        '${ImageKey.studyKey}_${ImageKey.seriesKey}_${imageIndex}_$windowIndex.png';
    if (!File(imagePath).existsSync()) {
      // 파일이 존재하지 않으면 초기 이미지로 돌아가기
      setState(() {
        currentImageIndex = 0;
        imageIndex = currentImageIndex + 1;
      });
    }
  }
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
          onChangeTheme: widget.onChangeTheme,
          backStatus: true,
        ),
        body: Center(
          child: Stack(
            children: [
              Obx(
                () => detailImageController.imagePathList.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 5.0,
                          ),
                        ),
                          Text("이미지 불러오는중 ...")
                        ],
                      )
                    : _buildImage(currentImageIndex),
              ),
              Positioned(
                
                top: 200,
                left: 0,
                child: selectedTabs.contains(0)
                    ? RotatedBox(
                        quarterTurns: 1,
                        child: Slider(
                          value: windowLevelSlider,
                          min: 1.0,
                         max: isAnimating ? 10.0 : 10.0,
          
                          onChanged: (value) {
                            setState(() {
                              
                              windowLevel(value);
                            
                            });
                          },
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                top: 200,
                right: 0,
                child: selectedTabs.contains(2)
                    ? RotatedBox(
                        quarterTurns: 1,
                        child: Slider(
                          value: scrollLoopSlider,
                          min: 1.0,
                          max: currentSeries.imagecnt.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              loop(value);
                            });
                          },
                        ),
                      )
                    : Container(),
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
                            CupertinoSlider(
                              value: animationSpeed.toDouble(),
                              min: 200,
                              max: 800,
                              onChanged: (value) {
                                setState(() {
                                  setAnimationSpeed(value.toInt());
                                });
                              },
                            ),
                            Text(
                              'Animation Speed: $animationSpeed',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              startAnimation();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('시작'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              stopAnimation();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('정지'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
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
              icon: Icon(Icons.flip),
              label: '좌우반전',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    bool bllowZoom = selectedTabs.contains(4); // 화면전환 탭
    return ColorFiltered(
      colorFilter: selectedTabs.contains(1)
          ? const ColorFilter.mode(
              Colors.white,
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
            imageProvider: FileImage(File(
                '${detailImageController.destinationDirectory.value}/${ImageKey.studyKey}_${ImageKey.seriesKey}_${imageIndex}_$windowIndex.png')),
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 10),
      ),
    );
  }

  void windowLevel(double value) {
    int index = (value * detailImageController.imagePathList.length).round();

    setState(() {
      currentImageIndex = index;
      windowLevelSlider = value;
      windowIndex = value.toInt();
    });
  }

  void loop(double value) {
    int index = (value * detailImageController.imagePathList.length).round();
    setState(() {
      currentImageIndex = index;
      scrollLoopSlider = value;
      imageIndex = value.toInt();
    });
  }
}
