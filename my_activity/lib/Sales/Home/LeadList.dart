import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_activity/Sales/Home/Page/Lead/AddNewLead.dart';
import 'package:my_activity/Sales/Home/Page/Lead/LeadDetail.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  _LeadListState createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  String searchQuery = '';
  String selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();
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
            .where((lead) => ['Open', 'Win', 'OnProgress'].contains(lead['status']))
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


  Widget leadItem({
    required Map<String, dynamic> lead,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LeadDetail(id: lead['id']),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  lead['image'] ?? 'https://via.placeholder.com/150',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead['clientName'] ?? 'Unknown Client',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Progress: ${(lead['progress'] ?? 0).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (lead['progress'] ?? 0) / 100,
                      color: Colors.blue,
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lead['typeLead'] == 'Self'
                      ? Colors.blue
                      : Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lead['typeLead'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Lead List",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      labelText: 'Search',
                      hintText: 'Search something...',
                      contentPadding: const EdgeInsets.symmetric(vertical: 1),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 161, 161, 161),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedFilter = newValue;
                          });
                        }
                      },
                      items: <String>['All', 'Self', 'Reff']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: RawScrollbar(
                  thumbColor: Colors.blue,
                  radius: const Radius.circular(20),
                  thickness: 5,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return leadItem(lead: lead);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddNewlead(),
                    ),
                  );
                },
                label: const Text(
                  'Add',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}