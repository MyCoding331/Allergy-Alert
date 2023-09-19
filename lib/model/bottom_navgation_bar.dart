// ignore_for_file: library_private_types_in_public_api

import 'package:allergyalert/screens/home/home.dart';
import 'package:allergyalert/screens/settings/setting_page.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    // const BarcodeScannerPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     _getAppBarTitle(_currentIndex),
      //     style: const TextStyle(
      //         color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   shadowColor: Colors.transparent,
      //   backgroundColor: Colors.white,
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 4,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.white : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _currentIndex == 1 ? Colors.white : Colors.grey,
            ),
            label: 'Settings',
          ),
        ]
            .asMap()
            .map((index, item) {
              return MapEntry(
                index,
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue
                          .withOpacity(_currentIndex == index ? 1.0 : 0.0),
                      borderRadius: BorderRadius.circular(16000),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        item.icon,
                        const SizedBox(width: 8),
                        Text(
                          item.label!,
                          style: TextStyle(
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: '',
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }
}

String _getAppBarTitle(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return 'Home';
    case 1:
      return 'Setting';
    // case 2:
    //   return 'Setting';
    default:
      return 'Home';
  }
}
