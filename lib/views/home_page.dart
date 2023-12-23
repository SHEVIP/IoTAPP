import 'package:flutter/material.dart';
import 'package:untitled/views/moments/moments_page.dart';
import 'package:untitled/views/board_page.dart';
import 'package:untitled/views/info/my_info.dart';
import 'package:untitled/views/work_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List _widgetOptions = [
    WorkPage(),
    BoardPage(),
    MomentsPage(),
    MyInfoPage()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '工作台'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '看板'),
          BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_strong), label: '工友圈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_strong), label: '我的'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
