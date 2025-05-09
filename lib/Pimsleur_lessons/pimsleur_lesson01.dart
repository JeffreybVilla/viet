import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:html' as html;

class PimsleurLesson01 extends StatefulWidget {
  const PimsleurLesson01({super.key});

  @override
  State<PimsleurLesson01> createState() => _PimsleurLesson01State();
}

class _PimsleurLesson01State extends State<PimsleurLesson01> {
  List<Map<String, dynamic>> words = [];
  Set<String> played = {};
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final jsonString = await rootBundle.loadString('assets/data/lesson01_words.json');
    final decoded = jsonDecode(jsonString);
    setState(() {
      words = List<Map<String, dynamic>>.from(decoded);
    });
  }

  void _playAudio(String fileName, String wordKey) {
    html.AudioElement()
      ..src = "assets/audio/lesson01_audio/$fileName"
      ..autoplay = true;

    setState(() {
      played.add(wordKey);
    });
  }

  void _toggleFavorite(String wordKey) {
    setState(() {
      if (favorites.contains(wordKey)) {
        favorites.remove(wordKey);
      } else {
        favorites.add(wordKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pimsleur Lesson 01')),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          final key = word['english'];
          return ListTile(
            title: Text(
              word['vietnamese'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(word['english'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _playAudio(word['audio'], key),
                ),
                IconButton(
                  icon: Icon(
                    favorites.contains(key) ? Icons.star : Icons.star_border,
                    color: favorites.contains(key) ? Colors.amber : null,
                  ),
                  onPressed: () => _toggleFavorite(key),
                ),
                if (played.contains(key))
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }
}
