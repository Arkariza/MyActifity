import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final Map<DateTime, Map<String, List<Map<String, String>>>> _activities = {};

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedActivities = prefs.getStringList('activities') ?? [];
    
    Map<DateTime, Map<String, List<Map<String, String>>>> loadedActivities = {};
    for (var activityJson in savedActivities) {
      Map<String, dynamic> activity = jsonDecode(activityJson);
      DateTime activityDate = DateTime.parse(activity['date']);
      String type = activity['type'];
      String name = activity['name'];
      String time = activity['time'];

      loadedActivities.putIfAbsent(activityDate, () => {});
      loadedActivities[activityDate]?.putIfAbsent(type, () => []);
      loadedActivities[activityDate]?[type]?.add({'name': name, 'time': time});
    }

    setState(() {
      _activities.clear();
      _activities.addAll(loadedActivities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showMonthYearPicker(context),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextFormatter: (date, locale) =>
                        '${_getMonthName(date.month)} ${date.year}',
                    titleTextStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${_selectedDay.day} ${_getMonthName(_selectedDay.month)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ..._buildActivityList(_selectedDay),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = _focusedDay.year;
        int selectedMonth = _focusedDay.month;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Month and Year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(11, (index) {
                      int year = DateTime.now().year - 5 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      int month = index + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text(_getMonthName(month)),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(selectedYear, selectedMonth, 1);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  List<Widget> _buildActivityList(DateTime date) {
    final activityForDay = _activities[DateTime(date.year, date.month, date.day)];
    if (activityForDay == null) {
      return [
        const Text('No activities', style: TextStyle(fontSize: 16)),
      ];
    }

    List<Widget> widgets = [];
    activityForDay.forEach((type, details) {
      widgets.add(
        Text('$type:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
      widgets.addAll(details.map((detail) => ListTile(
            leading: Icon(
              type == 'Call' ? Icons.phone : Icons.location_on,
              color: Colors.blue,
            ),
            title: Text(detail['name']!),
            subtitle: Text(detail['time']!),
          )));
      widgets.add(const SizedBox(height: 10));
    });

    return widgets;
  }
}
