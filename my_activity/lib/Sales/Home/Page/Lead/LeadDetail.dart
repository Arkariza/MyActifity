import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_activity/Sales/Home/Page/ActifityHistory.dart';
import 'package:my_activity/Sales/Home/Page/Call/AddCall.dart';
import 'package:my_activity/Sales/Home/Page/Meet/AddMeet.dart';
import 'package:my_activity/Sales/Home/Page/Meet/MeetNow.dart';
import 'dart:convert';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadDetail extends StatefulWidget {
  final String id;

  const LeadDetail({super.key, required this.id});

  @override
  _LeadDetailState createState() => _LeadDetailState();
}

class _LeadDetailState extends State<LeadDetail> {
  Map<String, dynamic>? leadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeadDetail();
  }

  void _showCallPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Make a Call'),
          content: Text('Call ${leadData?['clientName'] ?? 'N/A'} at ${leadData?['numPhone'] ?? 'N/A'}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCall()),
                );
              },
              child: const Text('Call Later'),
            ),
            TextButton(
              onPressed: () {
                // Implement call functionality here
                Navigator.pop(context);
              },
              child: const Text('CallNow'),
            ),
          ],
        );
      },
    );
  }

  void _showMeetPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Schedule Meeting'),
          content: Text('Schedule a meeting with ${leadData?['clientName'] ?? 'N/A'}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMeet()),
                );
              },
              child: const Text('Meet Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Meetnow()),
                );
              },
              child: const Text('Meet Now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchLeadDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/leads/${widget.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          leadData = data['lead'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load lead details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching lead detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (leadData != null && leadData!['status'] != null) {
      switch (leadData!['status']) {
        case 'Open':
          progress = 0.25;
          break;
        case 'In Progress':
          progress = 0.5;
          break;
        case 'Pending':
          progress = 0.75;
          break;
        case 'Closed':
          progress = 1.0;
          break;
        default:
          progress = 0.0;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Lead Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://i.pinimg.com/564x/61/fd/15/61fd15e4ad47d703dc4cdcb05d26b298.jpg',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            leadData?['clientName'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Progress: ${(progress * 100).toInt()}%",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            barRadius: const Radius.circular(10),
                            lineHeight: 8.0,
                            percent: progress,
                            backgroundColor: Colors.grey.shade200,
                            progressColor: Colors.blue,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Phone Number: ${leadData?['numPhone'] ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Number Policy: ${leadData?['noPolicy'] ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showCallPopup,
                                  icon: const Icon(Icons.phone, color: Colors.blue),
                                  label: const Text('Call'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    side: const BorderSide(color: Colors.blue),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showMeetPopup,
                                  icon: const Icon(Icons.videocam, color: Colors.blue),
                                  label: const Text('Meet'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    side: const BorderSide(color: Colors.blue),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ActivityHistory(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Activity History',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}