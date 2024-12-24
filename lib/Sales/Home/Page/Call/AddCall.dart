import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddCall(),
    );
  }
}

class AddCall extends StatefulWidget {
  const AddCall({super.key});

  @override
  _AddCallState createState() => _AddCallState();
}

class _AddCallState extends State<AddCall> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> _addCall() async {
    if (_clientNameController.text.isEmpty) {
      _showSnackBar('Please enter client name');
      return;
    }
    if (_phoneNumberController.text.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }
    if (_noteController.text.isEmpty) {
      _showSnackBar('Please enter the note');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showSnackBar('Authentication token not found. Please log in again.');
      return;
    }

    final callData = {
      'client_name': _clientNameController.text,
      'phonenum': _phoneNumberController.text,
      'note': _noteController.text
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/calls/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(callData),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Call added successfully');
      } else {
        _showSnackBar('Call Successfully: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  'Add Call',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Call',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _clientNameController,
                        decoration: InputDecoration(
                          prefixIcon: const Opacity(
                            opacity: 0.5,
                            child: Icon(Icons.person),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Client Name',
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          prefixIcon: const Opacity(
                            opacity: 0.5,
                            child: Icon(Icons.phone),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          prefixIcon: const Opacity(
                            opacity: 0.5,
                            child: Icon(Icons.note),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Note',
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addCall,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Add Call',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}