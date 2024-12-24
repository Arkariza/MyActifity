import 'package:flutter/material.dart';
import 'package:my_activity/Sales/Home/Page/Meet/AddMeet.dart';
import 'package:my_activity/Sales/Home/Page/Meet/MeetDate.dart';
import 'package:my_activity/Sales/Home/Page/Call/AddCall.dart';
import 'package:my_activity/Sales/Home/Page/Call/CallDate.dart';
import 'package:my_activity/Sales/Home/Page/PendingAssigment.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              "Sales Activity",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: _buildActivityCard(
        context: context,
        icon: Icons.call_rounded,
        title: "Calls",
        count: 5,
        firstButtonText: "Call Now",
        secondButtonText: "Call Later",
        firstButtonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CallDate()),
          );
        },
        secondButtonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCall()),
          );
        },
      ),
    ),
    const SizedBox(width: 10),
    Flexible(
      child: _buildActivityCard(
        context: context,
        icon: Icons.person_rounded,
        title: "Meet",
        count: 5,
        firstButtonText: "Meet Now",
        secondButtonText: "Meet Later",
        firstButtonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeetDate()),
          );
        },
        secondButtonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMeet()),
          );
        },
      ),
    ),
  ],
),
const SizedBox(height: 15),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: _buildDateButton(
        icon: Icons.call,
        label: "Call Date",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CallDate()),
          );
        },
      ),
    ),
    const SizedBox(width: 10),
    Flexible(
      child: _buildDateButton(
        icon: Icons.calendar_today,
        label: "Meeting Date",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeetDate()),
          );
        },
      ),
    ),
  ],
),
            const SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTeamSalesSection(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildActivityCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required int count,
  required String firstButtonText,
  required String secondButtonText,
  required VoidCallback firstButtonAction,
  required VoidCallback secondButtonAction,
}) {
  return Container(
    padding: const EdgeInsets.all(8.0), 
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue), 
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: firstButtonAction,
              child: Text(
                firstButtonText,
                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 16), 
            GestureDetector(
              onTap: secondButtonAction,
              child: Text(
                secondButtonText,
                style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildDateButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 178,
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSalesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Team Sales By Stage",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        _buildTeamRow(context, "Team Sales A"),
        _buildTeamRow(context, "Team Sales B"),
        _buildTeamRow(context, "Team Sales C"),
      ],
    );
  }

  Widget _buildTeamRow(BuildContext context, String teamName) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Text(
        teamName,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSalesStageBox(context, "Open", Colors.blue, 5, width: 60, height: 70),
          _buildSalesStageBox(context, "Meet", Colors.blue, 5, width: 60, height: 70),
          _buildSalesStageBox(context, "Pending", Colors.blue, 5, width: 60, height: 70),
          _buildSalesStageBox(context, "Win", const Color.fromARGB(255, 77, 221, 182), 5, isSpecial: true, width: 60, height: 70),
          _buildSalesStageBox(context, "Lose", const Color.fromARGB(255, 202, 48, 51), 5, isSpecial: true, width: 60, height: 70),
        ],
      ),
    ],
  );
}

Widget _buildSalesStageBox(
  BuildContext context,
  String label,
  Color color,
  int count, {
  double width = 50,
  double height = 65,
  bool isSpecial = false,
}) {
  return Flexible(
    child: GestureDetector(
      onTap: label == "Pending"
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pendingassigment()),
              );
            }
          : null,
      child: Container(
        width: width, 
        height: height, 
        decoration: BoxDecoration(
          color: isSpecial ? color : Colors.white,
          border: isSpecial ? const Border() : Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSpecial ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "$count",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSpecial ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
