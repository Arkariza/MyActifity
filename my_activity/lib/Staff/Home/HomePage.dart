import 'package:flutter/material.dart';
import 'package:my_activity/Staff/Home/Page/OnProgres.dart';
import 'package:my_activity/Staff/Home/Page/OpenLead.dart';
import 'package:my_activity/Staff/Home/Page/PendingPage.dart';
import 'package:my_activity/Staff/Home/Page/WinLosePage.dart';

class HomePageStaff extends StatelessWidget {
  const HomePageStaff({super.key});
  
  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Faust Darwin',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/user.jpeg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 250,
              color: Colors.grey[200],
              child: Center(
                child: Text('Chart In Here'),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                    context, Icons.person, "OPEN", "6", Colors.orange, OpenLead()),
                _buildStatCard(
                    context, Icons.bar_chart, "ON PROGRESS", "6", Colors.blue, OnProgres()),
              ],
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                    context, Icons.pending, "PENDING", "6", Colors.green, PendingPage()),
                _buildStatCard(
                    context, Icons.attach_money, "WIN/LOSE", "5:1", Colors.purple, WinLosePage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String label, String value, Color color, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: 165,
        height: 65,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 35, color: color),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}