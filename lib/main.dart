// main.dart - Starter Flutter Web App for Vietnamese Learning
import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const VietnameseApp());
}

class VietnameseApp extends StatelessWidget {
  const VietnameseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Vietnamese',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            child: ListTile(
              title: Text(lesson['title']!),
              subtitle: Text('Tap to learn more'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonPage(lesson: lesson),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LessonPage extends StatefulWidget {
  final Map<String, String> lesson;

  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  void _playAudio() {
  // Manually map accented words to safe filenames
  final overrideFilenames = {
    'Xin chào': 'xin_chao',
    'Ba mẹ': 'ba_me',
    'Phở': 'pho',
    'Sân bay': 'san_bay',
  };

  final safeName = overrideFilenames[widget.lesson['word']] ?? 'default';
  final filePath = 'assets/audio/$safeName.mp3';
  print('Playing with HTML5 audio: $filePath');

  final audio = html.AudioElement()
    ..src = filePath
    ..autoplay = true;

  audio.onError.listen((event) {
    print('HTML5 Audio Error: Could not load $filePath');
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Word: ${widget.lesson['word']}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Translation: ${widget.lesson['translation']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Pronunciation: [${widget.lesson['pronunciation']}]', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _playAudio,
              icon: const Icon(Icons.volume_up),
              label: const Text('Hear Pronunciation'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}