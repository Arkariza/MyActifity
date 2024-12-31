import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewlead extends StatefulWidget {
  const AddNewlead({super.key});

  @override
  _AddNewleadState createState() => _AddNewleadState();
}

class _AddNewleadState extends State<AddNewlead> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _numPhoneController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _addNewLead() async {
    if (_clientNameController.text.isEmpty) {
      _showSnackBar('Please enter client name');
      return;
    }
    if (_numPhoneController.text.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }
    if (_priorityController.text.isEmpty) {
      _showSnackBar('Please select priority');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showSnackBar('Authentication token not found. Please log in again.');
      return;
    }

    final leadData = {
      "clientname": _clientNameController.text,
      "numphone": _numPhoneController.text,
      "priority": _priorityController.text,
      "information": _informationController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/leads/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(leadData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _showSnackBar(responseData['message'] ?? 'Lead added successfully');
      } else {
        _showSnackBar('${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Add New Lead',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New Lead",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _clientNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Client Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _numPhoneController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Phone Number',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PriorityDropdown(
                    onChanged: (value) {
                      _priorityController.text = value ?? '';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _informationController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.info_outlined),
                      hintText: 'Information',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _addNewLead,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityDropdown extends StatefulWidget {
  final Function(String?) onChanged;
  const PriorityDropdown({required this.onChanged, super.key});

  @override
  _PriorityDropdownState createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  String? selectedPriority;
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: 'Select Priority',
      ),
      value: selectedPriority,
      icon: const Icon(Icons.arrow_drop_down),
      items: priorities.map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedPriority = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}