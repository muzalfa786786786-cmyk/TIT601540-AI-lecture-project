import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Posts"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            /// Profile Section
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                "lib/screens/image.png"),
            ),

            const SizedBox(height: 10),

            const Text(
              "Muzalfa Bibi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Flutter Developer | Web Engineering Student",
              style: TextStyle(color: Colors.green),
            ),

            const SizedBox(height: 20),

            /// Posts
            Expanded(
              child: ListView(
                children: const [

                  PostCard(
                    title: "Post 1",
                    text: "Learning Flutter is fun and powerful 🚀",
                  ),

                  PostCard(
                    title: "Post 2",
                    text: "Today I created my Profile & Posts App in Flutter.",
                  ),

                  PostCard(
                    title: "Post 3",
                    text: "Structured widgets make code clean and readable.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Post Card Widget
class PostCard extends StatelessWidget {
  final String title;
  final String text;

  const PostCard({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(text),
      ),
    );
  }
}