import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddRefeal extends StatefulWidget {
  const AddRefeal({super.key});

  @override
  _AddRefealState createState() => _AddRefealState();
}

class _AddRefealState extends State<AddRefeal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedPriority;
  String? selectedAssignTo;
  List<Map<String, dynamic>> assignToOptions = [];

  @override
  void initState() {
    super.initState();
    fetchAssignToOptions();
  }

  Future<void> fetchAssignToOptions() async {
    const String apiUrl = "http://localhost:8080/api/users/";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null. User might not be authenticated.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('users')) {
          final List<dynamic> users = data['users'];
          setState(() {
            assignToOptions = users
                .where((user) => user['role'] == 1)
                .map((user) => {
                      "username": user['username'] ?? "Unknown",
                    })
                .toList();
          });
        } else {
          print(
              'Unexpected data format: Missing "users" key or invalid structure');
        }
      } else {
        print('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> submitRefeal({
    required String name,
    required String phone,
    required String priority,
    required String assignTo,
    required String note,
  }) async {
    const String apiUrl = "http://localhost:8080/api/leads/add";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null. Submission cannot proceed.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'clientname': name,
          'numphone': phone,
          'priority': priority,
          'assign_to': assignTo,
          'information': note,
        }),
      );

      if (response.statusCode == 201) {
        print('Refeal submitted successfully!');
      } else {
        print('Failed to submit refeal: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  InputDecoration getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Refeal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Add New Refeal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Name Policy Holders',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 13),
                  decoration: getInputDecoration('Input Client Name'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: phoneController,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.phone,
                  decoration: getInputDecoration('+62xxxxxxxxxxx'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Priority',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  decoration: getInputDecoration('Select Priority'),
                  value: selectedPriority,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  items: ['High', 'Medium', 'Low'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Assign To (BFA)',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: DropdownButtonFormField<String>(
                    decoration: getInputDecoration('Select Assign To'),
                    value: selectedAssignTo,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    items: assignToOptions.map((user) {
                      return DropdownMenuItem<String>(
                        value: user['username'],
                        child: Text(user['username'] ?? "Unknown"),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAssignTo = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Note',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 3,
                  decoration: getInputDecoration('....'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          selectedPriority != null &&
                          selectedAssignTo != null &&
                          noteController.text.isNotEmpty) {
                        submitRefeal(
                          name: nameController.text,
                          phone: phoneController.text,
                          priority: selectedPriority!,
                          assignTo: selectedAssignTo!,
                          note: noteController.text,
                        );
                      } else {
                        print("All fields must be filled!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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