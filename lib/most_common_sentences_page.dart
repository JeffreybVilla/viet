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
  int _currentIndex = -1;
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
    setState(() {
      _isPlayingAll = true;
      _currentIndex = 0;
    });
    while (_isPlayingAll && _currentIndex < _sentences.length) {
      setState(() {});
      final sentence = _sentences[_currentIndex];
      final audioPath = sentence['audio'];

      if (audioPath == null || audioPath is! String || audioPath.isEmpty) {
        debugPrint("Invalid audio path at index $_currentIndex: $audioPath");
        _currentIndex++;
        setState(() {});
        continue;
      }

      print("Now playing: ${sentence['vietnamese']} ($audioPath)");

      await _audioPlayer.setSource(AssetSource("audio/most_common_sentences/$audioPath"));
      setState(() {}); // To update highlight
      await _audioPlayer.resume();
      await _audioPlayer.onPlayerComplete.first;

      if (!_isPlayingAll) break;

      _currentIndex++;
      setState(() {});

      if (_currentIndex >= _sentences.length && _loop) {
        setState(() => _currentIndex = 0);
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
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _sentences.map((sentence) {
          final index = _sentences.indexOf(sentence);
          final isCurrent = index == _currentIndex;
          final audioPath = sentence['audio'];

          return InkWell(
            onTap: () async {
              if (audioPath != null && audioPath is String && audioPath.isNotEmpty) {
                setState(() {
                  _currentIndex = index;
                  _isPlayingAll = false;
                });
                await _audioPlayer.play(AssetSource("audio/most_common_sentences/$audioPath"));
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 24, // 2 cards per row
              child: Card(
                color: isCurrent ? Colors.yellow[100] : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
  mainAxisAlignment: MainAxisAlignment.center,    // Center vertically
  mainAxisSize: MainAxisSize.min, // Shrink to fit content
  children: [
    Text(
      sentence['vietnamese'] ?? '',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      textAlign: TextAlign.center,  // Center text horizontally
      softWrap: true,
      overflow: TextOverflow.visible,
    ),
    const SizedBox(height: 4),
    Text(
      sentence['english'] ?? '',
      style: const TextStyle(fontSize: 12),
      textAlign: TextAlign.center,  // Center text horizontally
      softWrap: true,
      overflow: TextOverflow.visible,
    ),
    if (sentence.containsKey('mnemonic'))
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '💡 ${sentence['mnemonic']}',
          style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,  // Center text horizontally
          softWrap: true,
          overflow: TextOverflow.visible,
        ),

                        ),
                      const SizedBox(height: 6),
                      if (sentence.containsKey('mnemonic_image') && sentence['mnemonic_image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            sentence['mnemonic_image'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  ),
)





          ],
        ),
      ),
    );
  }
}
