import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:html' as html;

class PimsleurLesson02 extends StatefulWidget {
  const PimsleurLesson02({super.key});

  @override
  State<PimsleurLesson02> createState() => _PimsleurLesson02State();
}

class _PimsleurLesson02State extends State<PimsleurLesson02> {
  List<Map<String, dynamic>> words = [];
  Set<String> playedWords = {};

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final jsonString = await rootBundle.loadString('assets/data/lesson02_words.json');
    final decoded = jsonDecode(jsonString);
    setState(() {
      words = decoded.cast<Map<String, dynamic>>();
    });
  }

  void _playAudio(String filename) {
    final path = 'assets/audio/lesson02_audio/$filename';
    final audio = html.AudioElement()
      ..src = path
      ..autoplay = true;

    audio.onError.listen((event) {
      print('⚠️ Audio failed to load: $path');
    });

    setState(() {
      playedWords.add(filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = words.isEmpty ? 0 : playedWords.length / words.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Pimsleur Lesson 02')),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
              final item = words[index];
              final audio = item['audio'];
              final isPlayed = playedWords.contains(audio);
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.lightGreen[50],
                elevation: 2,
                child: ListTile(
                  onTap: () => _playAudio(audio),
                  title: Text(
                    item['vietnamese'] ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['english'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPlayed)
                        const Icon(Icons.check_circle, color: Colors.green),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _playAudio(audio),
                      ),
                    ],
                  ),
                ),
              );
            },

            ),
          ),
        ],
      ),
    );
  }
}
