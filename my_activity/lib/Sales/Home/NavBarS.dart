import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_activity/Sales/Home/Activity.dart';
import 'package:my_activity/Sales/Home/Dashboard.dart';
import 'package:my_activity/Sales/Home/HomeScreen.dart';
import 'package:my_activity/Sales/Home/LeadList.dart';
import 'package:my_activity/Sales/Home/Profile.dart';

class NavBars extends StatefulWidget {
  const NavBars({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBars> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const Dashboard(),
    const LeadList(),
    const Activity(),
    const Profile(),
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
            Icon(Icons.dashboard, size: 30),
            Icon(Icons.contacts_outlined, size: 30),
            Icon(Icons.star_outline_outlined, size: 30),
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
