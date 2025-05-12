import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class MostCommonSentencesPage extends StatefulWidget {
  const MostCommonSentencesPage({super.key});

  @override
  State<MostCommonSentencesPage> createState() => _MostCommonSentencesPageState();
}

class _MostCommonSentencesPageState extends State<MostCommonSentencesPage> {
  List<Map<String, dynamic>> sentences = [];

  @override
  void initState() {
    super.initState();
    loadSentences();
  }

  Future<void> loadSentences() async {
    final data = await rootBundle.loadString('assets/data/most_common_sentences.json');
    final List<dynamic> decoded = jsonDecode(data);
    setState(() {
      sentences = decoded.cast<Map<String, dynamic>>();
    });
  }

  void _playAudio(String fileName) {
    final audio = html.AudioElement()
      ..src = 'assets/audio/most_common_sentences/$fileName'
      ..autoplay = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Most Common Sentences')),
      body: sentences.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sentences.length,
              itemBuilder: (context, index) {
                final sentence = sentences[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () => _playAudio(sentence['audio'] ?? ''),
                    child: Text(
                      sentence['vietnamese'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(sentence['english'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _playAudio(sentence['audio'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
