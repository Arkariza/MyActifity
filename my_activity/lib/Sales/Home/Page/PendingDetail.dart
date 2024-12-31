import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PendingDetail extends StatefulWidget {
  final String id;

  const PendingDetail({super.key, required this.id});

  @override
  State<PendingDetail> createState() => _PendingDetailState();
}

class _PendingDetailState extends State<PendingDetail> {
  Map<String, dynamic>? leadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeadDetail();
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
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leadData == null
              ? const Center(child: Text('No data found'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Row(
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
                            'Pending Detail',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      const Text("Name Policy Holders"),
                      const SizedBox(height: 8),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: leadData?['clientName'] ?? 'N/A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Phone Number"),
                      const SizedBox(height: 8),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: leadData?['numPhone'] ?? 'N/A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Priority"),
                      const SizedBox(height: 8),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: leadData?['priority'] ?? 'N/A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("NoPolicy"),
                      const SizedBox(height: 8),
                      TextField(
                        enabled: false,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: leadData?['noPolicy'] != null 
                              ? leadData!['noPolicy'].toString() 
                              : 'N/A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}