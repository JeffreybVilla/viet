
import 'package:flutter/material.dart';
import 'lesson_page.dart';
import 'words_page.dart';
import 'Pimsleur_lessons/pimsleur_lesson02.dart';
import 'Pimsleur_lessons/00pimsleur_lessons_page.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      {'title': 'Greetings', 'word': 'Xin chào', 'translation': 'Hello', 'pronunciation': 'sin chow'},
      {'title': 'Family', 'word': 'Ba mẹ', 'translation': 'Parents', 'pronunciation': 'ba meh'},
      {'title': 'Food', 'word': 'Phở', 'translation': 'Noodle Soup', 'pronunciation': 'fuh'},
      {'title': 'Travel', 'word': 'Sân bay', 'translation': 'Airport', 'pronunciation': 'sun bye'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Learn Vietnamese')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Words main category
          Card(
            child: ListTile(
              leading: Image.asset('assets/images/male_cartoon.png', height: 50),
              title: const Text('Words'),
              subtitle: const Text('Explore vocabulary by category'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WordsPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text('Pimsleur Lessons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Image.asset(
              'assets/images/pimsleur_icon.png', // <-- your image path
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
            title: const Text(
              'Pimsleur Lessons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Audio-based vocabulary training'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PimsleurLessonsPage()),
              );
            },
          ),
        ),

          const SizedBox(height: 20),

          ...lessons.map((lesson) {
            return Card(
              child: ListTile(
                title: Text(lesson['title']!),
                subtitle: const Text('Tap to learn more'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonPage(lesson: lesson),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
