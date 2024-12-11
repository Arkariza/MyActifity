import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_activity/Sales/Home/Page/CreatePost.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HOME',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOw13N1quoQo_eK_UZMVNxAdfNcKge5HK94A&s'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 185,
              width: 1000,
              child: ImageSlider(isNetwork: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MY CIRCLE STORIES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreatePost()),
                    );
                  },
                  child: const Text(
                    '+ Add Comment',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildStoryCard(context, 'Sebastian Wicaksono', 'Ini Benar-Benar Mengagumkan', '1 hour ago'),
                _buildStoryCard(context, 'Agus Jackson', 'Saya Suka dengan Layanan ini', '15 hours ago'),
                _buildStoryCard(context, 'Dimas Nugraha', 'Saya Suka update baru ini; Semakin Menarik', '5 hours ago'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, String name, String content, String time) {
    return StoryCard(
      name: name,
      content: content,
      time: time,
    );
  }
}

class StoryCard extends StatefulWidget {
  final String name;
  final String content;
  final String time;

  const StoryCard({
    Key? key,
    required this.name,
    required this.content,
    required this.time,
  }) : super(key: key);

  @override
  _StoryCardState createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  int likeCount = 0;
  List<String> comments = [];

  void _toggleLike() {
    setState(() {
      likeCount++;
    });
  }

  void _showCommentSection() {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: comments
                          .map((comment) => ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://example.com/user_avatar.jpg'),
                                ),
                                title: const Text('User'),
                                subtitle: Text(comment),
                              ))
                          .toList(),
                    ),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          setModalState(() {
                            comments.add(commentController.text);
                          });
                          commentController.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://example.com/user_avatar.jpg',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    SizedBox(
                      width: max(155, 200),
                      child: Text(widget.content),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up, color: Colors.blue),
                              onPressed: _toggleLike,
                            ),
                            Text('$likeCount'),
                          ],
                        ),
                        const SizedBox(width: 35),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.blue),
                              onPressed: _showCommentSection,
                            ),
                            Text('${comments.length}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  final bool isNetwork;

  ImageSlider({super.key, required this.isNetwork});

  final List<String> networkImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb6Rzo_PBz9RnBQ9KgAtcZ1rZsrPQq5bS5xw&s',
    'https://d33wubrfki0l68.cloudfront.net/b4759e96fa9ada8ee8caa4c771fcd503f289d791/6de77/static/triangle_background-9df4fa2e10f0e294779511e99083c2bc.jpg',
    'https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2020/07/shutterstock_582803470.jpg?w=750',
  ];

  final List<String> localImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb6Rzo_PBz9RnBQ9KgAtcZ1rZsrPQq5bS5xw&s',
    'https://d33wubrfki0l68.cloudfront.net/b4759e96fa9ada8ee8caa4c771fcd503f289d791/6de77/static/triangle_background-9df4fa2e10f0e294779511e99083c2bc.jpg',
    'https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2020/07/shutterstock_582803470.jpg?w=750',
  ];

  @override
  Widget build(BuildContext context) {
    final images = isNetwork ? networkImages : localImages;

    return CarouselSlider(
      items: images.map((imagePath) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: isNetwork
                ? Image.network(imagePath, fit: BoxFit.cover)
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 185.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
    );
  }
}