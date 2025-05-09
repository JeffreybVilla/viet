import 'package:flutter/material.dart';
import 'dart:html' as html; // ✅ required for Flutter Web

class BasicWordsPage extends StatefulWidget {
  const BasicWordsPage({super.key});

  @override
  State<BasicWordsPage> createState() => _BasicWordsPageState();
}

class _BasicWordsPageState extends State<BasicWordsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = [
    'Pronouns',
    'Interrogative',
    'Conjunction',
    'Other'
  ];

  final Map<String, List<Map<String, String>>> wordsByTab = {
    'Pronouns': [
      {'word': 'Tôi', 'translation': 'I / Me', 'pronunciation': 'toy'},
      {'word': 'Bạn', 'translation': 'You', 'pronunciation': 'ban'},
      {'word': 'Chúng tôi', 'translation': 'We', 'pronunciation': 'choong toy'},
    ],
    'Interrogative': [],
    'Conjunction': [],
    'Other': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void _playAudio(String word) {
    final overrideFilenames = {
      'Tôi': 'toi',
      'Bạn': 'ban',
      'Chúng tôi': 'chung_toi',
    };

    final fileSafeName = overrideFilenames[word] ?? 'default';
    final path = 'assets/audio/$fileSafeName'; // ✅ no \$ needed

    final audio = html.AudioElement()
      ..src = path
      ..autoplay = true;

    audio.onError.listen((event) {
      print('❌ Audio load error: $path');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Words')),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) {
          final words = wordsByTab[tab] ?? [];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final word = words[index];
              return ListTile(
                title: GestureDetector(
                  onTap: () => _playAudio(word['word']!),
                  child: Text(
                    word['word']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                subtitle: Text(
                    '${word['translation']} • ${word['pronunciation']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _playAudio(word['word']!),
                ),
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: tabs.map((label) => Tab(text: label)).toList(),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
    );
  }
}
