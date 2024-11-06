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
        padding: EdgeInsets.only(left: 15, right: 15, top: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 35),
            Text(
              "Sales Activity",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActivityCard(
                  context: context,
                  icon: Icons.call_rounded,
                  title: "Calls",
                  count: 5,
                  firstButtonText: "Call Now",
                  secondButtonText: "Call Later",
                  firstButtonAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CallDate()),
                    );
                  },
                  secondButtonAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCall()),
                    );
                  },
                ),
                _buildActivityCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: "Meet",
                  count: 5,
                  firstButtonText: "Meet Now",
                  secondButtonText: "Meet Later",
                  firstButtonAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MeetDate()),
                    );
                  },
                  secondButtonAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeet()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateButton(
                  icon: Icons.call,
                  label: "Call Date",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CallDate()),
                    );
                  },
                ),
                _buildDateButton(
                  icon: Icons.calendar_today,
                  label: "Meeting Date",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MeetDate()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 35),
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
      width: 184,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue, size: 40),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$count",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: firstButtonAction,
                    child: Text(
                      firstButtonText,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: secondButtonAction,
                    child: Text(
                      secondButtonText,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
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
        Text(
          "Team Sales By Stage",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        Text(
          teamName,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSalesStageBox(context, "Open", Colors.blue, 5),
            _buildSalesStageBox(context, "Meet", Colors.blue, 5),
            _buildSalesStageBox(context, "Pending", Colors.blue, 5),
            _buildSalesStageBox(context, "Win", Color.fromARGB(255, 77, 221, 182), 5, isSpecial: true),
            _buildSalesStageBox(context, "Lose", const Color.fromARGB(255, 202, 48, 51), 5, isSpecial: true),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesStageBox(BuildContext context, String label, Color color, int count, {bool isSpecial = false}) {
    return GestureDetector(
      onTap: label == "Pending"
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pendingassigment()),
              );
            }
          : null,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSpecial ? color : Colors.white,
          border: isSpecial ? Border() : Border.all(color: Colors.black),
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
            SizedBox(height: 5),
            Text(
              "$count",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSpecial ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}