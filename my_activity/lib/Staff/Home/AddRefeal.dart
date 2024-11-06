import 'package:flutter/material.dart';

class AddRefeal extends StatelessWidget {
  const AddRefeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Refeal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            const Text("Add New Refeal",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name Policy Holders',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: 'John Doe',
                hintStyle: const TextStyle(
                  fontSize: 12, 
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: '081234567890',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Select Priority',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
            const SizedBox(height: 5),
            PriorityDropdown(),
            const SizedBox(height: 10),
            const Text(
              'Assign To (BFA)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
            const SizedBox(height: 5),
            AssignToDropdown(),
            const SizedBox(height: 10),
            const Text(
              'Note',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: 'Lorem Ipsum',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
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

class PriorityDropdown extends StatefulWidget {
  const PriorityDropdown({super.key});

  @override
  _PriorityDropdownState createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  String? selectedPriority;
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Select Priority',
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
      ),
      value: selectedPriority,
      icon: const Icon(Icons.arrow_drop_down),
      items: priorities.map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(
            priority,
            style: const TextStyle(fontSize: 10), // Smaller font size
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedPriority = newValue;
        });
      },
    );
  }
}

class AssignToDropdown extends StatefulWidget {
  const AssignToDropdown({super.key});

  @override
  _AssignToDropdownState createState() => _AssignToDropdownState();
}

class _AssignToDropdownState extends State<AssignToDropdown> {
  String? selectedAssign;
  final List<String> assignOptions = ['Assign Now', 'Assign Later'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Assign Later',
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
      ),
      value: selectedAssign,
      icon: const Icon(Icons.arrow_drop_down),
      items: assignOptions.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: const TextStyle(fontSize: 10), // Smaller font size
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedAssign = newValue;
        });
      },
    );
  }
}