import 'package:flutter/material.dart';
import 'package:my_activity/Sales/Home/Page/Lead/AddNewLead.dart';
import 'package:my_activity/Sales/Home/Page/Lead/LeadDetail.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  _LeadListState createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  String searchQuery = '';
  String selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();

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
                      prefixIcon: const Icon(Icons.search, size: 20,),
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
                      icon: const Icon(Icons.filter_list, color: Colors.black,),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                        });
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
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, 
                child: RawScrollbar(
                  thumbColor: Colors.blue,
                  radius: const Radius.circular(20),
                  thickness: 5,
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: [
                      leadItem(
                        image: 'https://via.placeholder.com/150',
                        name: 'Aprilia Scout',
                        progress: 5,
                        status: 'SELF',
                        badgeColor: Colors.blue,
                      ),
                      leadItem(
                        image: 'https://via.placeholder.com/150',
                        name: 'Budi Serazawa',
                        progress: 15,
                        status: 'REFF',
                        badgeColor: Colors.yellow,
                      ),
                      leadItem(
                        image: 'https://via.placeholder.com/150',
                        name: 'Asep Sitorus',
                        progress: 20,
                        status: 'REFF',
                        badgeColor: Colors.yellow,
                      ),
                      leadItem(
                        image: 'https://via.placeholder.com/150',
                        name: 'Qila Wulandari',
                        progress: 40,
                        status: 'REFF',
                        badgeColor: Colors.yellow,
                      ),
                    ],
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
                      builder: (context) => AddNewLead(),
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

  Widget leadItem({
    required String image,
    required String name,
    required int progress,
    required String status,
    required Color badgeColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LeadDetail(name: name, status: status),
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
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Progress: $progress%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
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
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
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
}