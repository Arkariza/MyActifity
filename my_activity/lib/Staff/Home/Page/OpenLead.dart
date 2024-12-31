import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenLead extends StatefulWidget {
  const OpenLead({Key? key}) : super(key: key);

  @override
  State<OpenLead> createState() => _OpenLeadState();
}

class _OpenLeadState extends State<OpenLead> {
  List<dynamic> openLeads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOpenLeads();
  }

  Future<void> fetchOpenLeads() async {
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
            openLeads = responseData['leads']
                .where((lead) => lead['status'] == 'Open')
                .toList();
            isLoading = false;
          });
        } else {
          _showSnackBar('Invalid response format: leads data is missing');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        _showSnackBar('Failed to fetch leads: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Error fetching leads: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                    'Open Lead',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "User's Open Lead",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : openLeads.isEmpty
                        ? const Center(child: Text('No Open Leads Found'))
                        : ListView.builder(
                            itemCount: openLeads.length,
                            itemBuilder: (context, index) {
                              final lead = openLeads[index];
                              return _buildOpenLeadCard(
                                policyHolder: lead['clientName'] ?? 'Unknown',
                                policyNumber: lead['noPolicy'].toString(),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpenLeadCard({
    required String policyHolder,
    required String policyNumber,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Policy Holder: $policyHolder',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Policy Number: $policyNumber',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}