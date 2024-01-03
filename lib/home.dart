import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
// aas
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PACSPLUS2'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {

              }, 
              child: const Text("홈페이지로 이동"),
            ),
          ],
        ),
      ),
    );
  }
}