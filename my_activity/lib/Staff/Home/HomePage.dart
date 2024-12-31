import 'package:flutter/material.dart';
import 'package:my_activity/Staff/Home/Page/OnProgres.dart';
import 'package:my_activity/Staff/Home/Page/OpenLead.dart';
import 'package:my_activity/Staff/Home/Page/PendingPage.dart';
import 'package:my_activity/Staff/Home/Page/WinLosePage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePageStaff extends StatelessWidget {
  final String token;
  const HomePageStaff({super.key, required this.token});
  
  @override
  Widget  build(BuildContext context) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String username = decodedToken['username'] ?? 'Username tidak tersedia';
    String image = decodedToken['image'] ?? 'assets/images/user.png';

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
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                ClipOval(
                  child: Image.network(
                    image,
                    width: 20,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Chart In Here'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                    context, Icons.person, "OPEN", "6", Colors.orange, const OpenLead()),
                _buildStatCard(
                    context, Icons.bar_chart, "ON PROGRESS", "6", Colors.blue, const OnProgres()),
              ],
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                    context, Icons.pending, "PENDING", "6", Colors.green, const PendingPage()),
                _buildStatCard(
                    context, Icons.attach_money, "WIN/LOSE", "5:1", Colors.purple, const WinLosePage()),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
