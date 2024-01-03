import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PACSPLUS3'),
         iconTheme: IconThemeData(
          color: Colors.red
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
    items:const <BottomNavigationBarItem>[
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
      selectedItemColor: Colors.red
      ),
    );
  }
}