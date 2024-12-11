import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OnProgres extends StatelessWidget {
  final List<Map<String, dynamic>> leads = [
    {"name": "Aprilia Scout", "progress": 0.05, "image": "assets/user1.png"},
    {"name": "Budi Serazawa", "progress": 0.15, "image": "assets/user2.png"},
    {"name": "Asep Sitorus", "progress": 0.20, "image": "assets/user3.png"},
    {"name": "Qila Wulandari", "progress": 0.40, "image": "assets/user4.png"},
    {
      "name": "Rangga Agustin",
      "progress": 1.0,
      "image": "assets/user5.png",
      "verified": true
    },
    {"name": "Aisyah September", "progress": 0.70, "image": "assets/user6.png"},
  ];

  OnProgres({super.key});

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
            child: ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return LeadCard(
                  name: lead['name'],
                  progress: lead['progress'],
                  imagePath: lead['image'],
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

  const LeadCard({super.key, 
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
                  backgroundImage: AssetImage(imagePath),
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
