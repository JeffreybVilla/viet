import 'package:flutter/material.dart';
import 'dart:html' as html;

class LessonPage extends StatelessWidget {
  final Map<String, String> lesson;

  const LessonPage({super.key, required this.lesson});

  void _playAudio(String word) {
    final overrideFilenames = {
      'Xin chào': 'xin_chao',
      'Ba mẹ': 'ba_me',
      'Phở': 'pho',
      'Sân bay': 'san_bay',
    };

    final safeName = overrideFilenames[word] ?? 'default';
    final filePath = 'assets/audio/$safeName.mp3';

    final audio = html.AudioElement()
      ..src = filePath
      ..autoplay = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Word: ${lesson['word']}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Translation: ${lesson['translation']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Pronunciation: [${lesson['pronunciation']}]', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _playAudio(lesson['word']!),
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
