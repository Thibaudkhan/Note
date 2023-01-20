import 'package:code/Widget/record.dart';
import 'package:code/Widget/record_page.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class MyNavbar extends StatefulWidget {
  @override
  _MyNavbarState createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    AudioRecorderWidget(),
    RecordList()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'Record'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),
        ],
      ),
    );
  }
}
