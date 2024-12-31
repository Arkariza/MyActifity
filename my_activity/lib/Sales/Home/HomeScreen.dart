import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_activity/Sales/Home/Page/CreatePost.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          Expanded(child: CommentsSection()),
        ],
      ),
    );
  }
}

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  late Future<List<Map<String, dynamic>>> commentsFuture;

  @override
  void initState() {
    super.initState();
    commentsFuture = fetchComments();
  }

  Future<List<Map<String, dynamic>>> fetchComments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/comments/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('comments')) {
        return List<Map<String, dynamic>>.from(data['comments']);
      } else if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Unexpected JSON format.');
      }
    } else {
      throw Exception('Failed to fetch comments: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments available yet.'));
        }

        final comments = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              commentsFuture = fetchComments();
            });
          },
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                              Text(
                                comment['posted_by'] ?? 'Anonymous',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                comment['date'] ?? 'Unknown date',
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        comment['description'] ?? 'No description',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up, color: Colors.blue),
                                onPressed: () {
                                },
                              ),
                              const Text('0'),
                            ],
                          ),
                          const SizedBox(width: 35),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.blue),
                                onPressed: () {
                                },
                              ),
                              const Text('0'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ImageSlider extends StatelessWidget {
  final bool isNetwork;

  ImageSlider({super.key, required this.isNetwork});

  final List<String> networkImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb6Rzo_PBz9RnBQ9KgAtcZ1rZsrPQq5bS5xw&s',
    'https://d33wubrfki0l68.cloudfront.net/b4759e96fa9ada8ee8caa4c771fcd503f289d791/6de77/static/triangle_background-9df4fa2e10f0e294779511e99083c2bc.jpg',
    'https://images.pexels.com/photos/531880/pexels-photo-531880.jpeg?cs=srgb&dl=pexels-pixabay-531880.jpg&fm=jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final images = isNetwork ? networkImages : [];

    return CarouselSlider(
      items: images.map((imagePath) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(imagePath, fit: BoxFit.cover),
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