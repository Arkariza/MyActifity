import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_activity/Staff/Home/AddRefeal.dart';
import 'package:my_activity/Staff/Home/DetailPage.dart';
import 'package:my_activity/Staff/Home/HomePage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const HomePageStaff(),
    const AddRefeal(),
    const DetailPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue, 
              width: 15.0,        
            ),
          ),
        ),
        child: CurvedNavigationBar(
          index: _pageIndex,
          items: const <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.person_add, size: 30),
            Icon(Icons.person, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blue,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
