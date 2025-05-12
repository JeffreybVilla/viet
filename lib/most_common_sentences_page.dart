import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class MostCommonSentencesPage extends StatefulWidget {
  const MostCommonSentencesPage({super.key});

  @override
  State<MostCommonSentencesPage> createState() => _MostCommonSentencesPageState();
}

class _MostCommonSentencesPageState extends State<MostCommonSentencesPage> {
    final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _sentences = [];
  bool _isPlayingAll = false;
  int _currentIndex = 0;
  bool _loop = false;

  @override
  void initState() {
    super.initState();
    _loadSentences();
  }

  Future<void> _loadSentences() async {
    final jsonString = await rootBundle.loadString('assets/data/most_common_sentences.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _sentences = jsonList.cast<Map<String, dynamic>>();
    });
  }

  void playAllSentences() async {
    setState(() => _isPlayingAll = true);
    while (_isPlayingAll && _sentences.isNotEmpty) {
      final sentence = _sentences[_currentIndex];
      final audioPath = sentence['audio'];

      if (audioPath == null || audioPath is! String || audioPath.isEmpty) {
        debugPrint("Invalid audio path at index $_currentIndex: $audioPath");
        _currentIndex++;
      setState(() {});
      setState(() {});
        continue;
      }

      print("Now playing: \${sentence['vietnamese']} (\$audioPath)");
      await _audioPlayer.play(AssetSource("audio/most_common_sentences/$audioPath"));
      await _audioPlayer.onPlayerComplete.first;

      _currentIndex++;
            if (_currentIndex >= _sentences.length) {
        if (_loop) {
          _currentIndex = 0;
        } else {
          break;
        }
      }
    }
    setState(() => _isPlayingAll = false);
  }

  void stopPlayingAll() {
    _audioPlayer.stop();
    setState(() => _isPlayingAll = false);
  }

  void skipToNext() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
        _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Most Common Sentences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _isPlayingAll ? null : playAllSentences,
                  child: const Text("Play All"),
                ),
                ElevatedButton(
                  onPressed: _isPlayingAll ? stopPlayingAll : null,
                  child: const Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: _isPlayingAll ? skipToNext : null,
                  child: const Text("Skip"),
                ),
                Row(
                  children: [
                    const Text("Loop"),
                    Switch(
                      value: _loop,
                      onChanged: (val) => setState(() => _loop = val),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                                itemCount: _sentences.length,
                itemBuilder: (context, index) {
                  final sentence = _sentences[index];
final isCurrent = index == _currentIndex && _isPlayingAll;
                  final sentenceText = sentence['vietnamese'] as String? ?? '[No sentence]';
                  final audioPath = sentence['audio'];

                  return Card(
  color: isCurrent ? Colors.yellow[100] : null,
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  child: ListTile(
                      title: Text(sentenceText),
                      subtitle: Text(sentence['english'] as String? ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () async {
                          if (audioPath != null && audioPath is String && audioPath.isNotEmpty) {
                            await _audioPlayer.play(AssetSource("audio/most_common_sentences/$audioPath"));
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
