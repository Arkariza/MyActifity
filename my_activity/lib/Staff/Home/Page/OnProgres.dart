import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnProgres extends StatefulWidget {
  const OnProgres({super.key});

  @override
  _OnProgresState createState() => _OnProgresState();
}

class _OnProgresState extends State<OnProgres> {
  List<dynamic> leads = [];

  @override
  void initState() {
    super.initState();
    fetchLeads();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showError(String message) {
    _showSnackBar(message);
  }

  Future<void> fetchLeads() async {
    const String apiUrl = 'http://localhost:8080/api/leads/';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _showSnackBar('Authentication token not found. Please log in again.');
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['leads'] != null) {
          setState(() {
            leads = responseData['leads']
                .where((lead) => lead['status'] == 'OnProgress')
                .toList();
          });
        } else {
          showError('Invalid response format: leads data is missing');
        }
      } else if (response.statusCode == 401) {
        showError('Invalid token. Please log in again.');
      } else {
        showError('Failed to fetch leads: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error fetching leads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'On-Progress Leads',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: leads.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return LeadCard(
                        name: lead['clientName'] ?? 'Unknown',
                        progress: (lead['progress'] ?? 0) / 100,
                        imagePath: lead['image'] ?? 'https://via.placeholder.com/150',
                        verified: lead['verified'] ?? false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final String name;
  final double progress;
  final String imagePath;
  final bool verified;

  const LeadCard({
    super.key,
    required this.name,
    required this.progress,
    required this.imagePath,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(imagePath),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (verified)
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Progress: ${(progress * 100).toInt()}%',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      LinearPercentIndicator(
                        barRadius: const Radius.circular(10),
                        lineHeight: 15.0,
                        percent: progress,
                        backgroundColor: Colors.grey.shade300,
                        progressColor: progress == 1.0 ? Colors.blue : Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}