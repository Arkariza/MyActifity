import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  List<Map<String, dynamic>> activities = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedActivities = prefs.getStringList('activities') ?? [];
    List<Map<String, dynamic>> parsedActivities = savedActivities
        .map((activity) => jsonDecode(activity) as Map<String, dynamic>)
        .toList();

    setState(() {
      activities = parsedActivities;
    });
  }

  List<Map<String, dynamic>> _filterActivitiesByDate(DateTime date) {
    String formattedDate = "${date.toLocal()}".split(' ')[0];
    return activities
        .where((activity) => activity['date'] == formattedDate)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredActivities =
        _filterActivitiesByDate(selectedDate);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Activity",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: filteredActivities.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity['type'],
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    activity['name'],
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                activity['time'] ?? 'All day',
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No activities available for the selected date.",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
