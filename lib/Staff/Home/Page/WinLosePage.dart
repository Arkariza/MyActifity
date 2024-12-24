import 'package:flutter/material.dart';

class WinLosePage extends StatelessWidget {
  const WinLosePage({Key? key}) : super(key: key);

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
                    'Win/Lose',
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
                "User's Win/Lose",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildResultCard(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9Njse2IRGeO4hx325KhANlY5NTCExg6wYsQ&s',
                      policyHolder: 'Ryuki Kajiwara',
                      bfaName: 'Welt Joyce',
                      status: 'Win',
                    ),
                    _buildResultCard(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9Njse2IRGeO4hx325KhANlY5NTCExg6wYsQ&s', 
                      policyHolder: 'Himeko',
                      bfaName: 'Welt Joyce',
                      status: 'Lose', 
                    ),
                    _buildResultCard(
                      imageUrl: 'https://i.imgur.com/hHNdInK.jpg', 
                      policyHolder: 'Peter Pete',
                      bfaName: 'Welt Joyce',
                      status: 'Win', 
                    ),
                    _buildResultCard(
                      imageUrl: 'https://i.imgur.com/7VRmdgJ.jpg', 
                      policyHolder: 'Erica Richard',
                      bfaName: 'Welt Joyce',
                      status: 'Lose', 
                    ),
                    _buildResultCard(
                      imageUrl: 'https://i.imgur.com/kL5TZWv.jpg', 
                      policyHolder: 'Adam Smith',
                      bfaName: 'Welt Joyce',
                      status: 'Lose', 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String imageUrl,
    required String policyHolder,
    required String bfaName,
    required String status, 
  }) {
    Color statusColor = status == 'Win' ? Colors.green : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Policy Holders: $policyHolder',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'BFA Name: $bfaName',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity, 
                    height: 30,  
                    padding: const EdgeInsets.symmetric(
                      vertical: 6, 
                    ),
                    decoration: BoxDecoration(
                      color: statusColor, 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      status, 
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, 
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