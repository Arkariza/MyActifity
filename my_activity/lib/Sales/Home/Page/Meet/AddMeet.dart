import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_activity/Sales/Home/Page/Location/maps_location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddMeet(),
    );
  }
}

class AddMeet extends StatefulWidget {
  const AddMeet({super.key});

  @override
  _AddMeetState createState() => _AddMeetState();
}

class _AddMeetState extends State<AddMeet> {
  String _addressText = 'Address';
  LatLng? _selectedLocation;

  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> _openMapsLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (result != null) {
      String? locationName = result['locationName'];
      LatLng location = LatLng(result['latitude'], result['longitude']);

      if (locationName != null) {
        setState(() {
          _addressText = 'Lat: ${location.latitude}, Lng: ${location.longitude}';
          _selectedLocation = location;
        });
      } else {
        _showSnackBar('Invalid location data');
      }
    }
  }

  Future<void> _addMeet() async {
    if (_clientNameController.text.isEmpty) {
      _showSnackBar('Please enter client name');
      return;
    }
    if (_phoneNumberController.text.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }
    if (_addressText == 'Address') {
      _showSnackBar('Please select location');
      return;
    }
    if (_selectedLocation == null) {
      _showSnackBar('Location not selected');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showSnackBar('Authentication token not found. Please log in again.');
      return;
    }

    final meetData = {
      'client_name': _clientNameController.text,
      'phone_num': _phoneNumberController.text,
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
      'note': _noteController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/meets/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
        body: jsonEncode(meetData),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Meet has been added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        _showSnackBar(errorBody['error'] ?? 'Failed to add meet');
      }
    } catch (e) {
      _showSnackBar('Error connecting to the server: $e');
    }
  }

  void _resetForm() {
    _clientNameController.clear();
    _phoneNumberController.clear();
    _noteController.clear();
    setState(() {
      _addressText = 'Address';
      _selectedLocation = null;
    });
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
                  'Add Meet',
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add Meet',
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
                          keyboardType: TextInputType.phone,
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
                        ElevatedButton(
                          onPressed: _openMapsLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15)   
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.black.withOpacity(0.5)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    _addressText,
                                    style: TextStyle(
                                      color: _addressText == 'Address'
                                        ? Colors.black.withOpacity(0.5) 
                                        : Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
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
                          onPressed: _addMeet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Add Meet',
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}