import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: SizedBox(
        width: MediaQuery.of(context).viewInsets.right,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // 메뉴 항목을 클릭했을 때의 동작 정의
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // 메뉴 항목을 클릭했을 때의 동작 정의
              },
            ),
            // 추가적인 메뉴 항목들을 원하는 만큼 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
