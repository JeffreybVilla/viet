import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:html' as html;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> allFavorites = [];
  Set<String> favoriteKeys = {};

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteKeys = prefs.getStringList('favorites')?.toSet() ?? {};

    final sources = [
      'assets/data/basic_words.json',
      'assets/data/lesson02_words.json',
    ];

    List<Map<String, dynamic>> words = [];

    for (final path in sources) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final decoded = jsonDecode(jsonString);

        if (decoded is Map<String, dynamic>) {
          decoded.forEach((_, wordList) {
            for (var word in wordList) {
              if (word is Map<String, dynamic> &&
                  favoriteKeys.contains(word['english'])) {
                words.add(word);
              }
            }
          });
        } else if (decoded is List) {
          for (var word in decoded) {
            if (word is Map<String, dynamic> &&
                favoriteKeys.contains(word['english'])) {
              words.add(word);
            }
          }
        }
      } catch (_) {}
    }

    setState(() {
      allFavorites = words;
    });
  }

  void _playAudio(String fileName) {
    final audio = html.AudioElement()
      ..src = "assets/audio/lesson02_audio/$fileName"
      ..autoplay = true;
    audio.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: allFavorites.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: allFavorites.length,
              itemBuilder: (context, index) {
                final word = allFavorites[index];
                return ListTile(
                  title: Text(word['english'] ?? ''),
                  subtitle: Text(word['vietnamese'] ?? ''),
                  leading: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _playAudio(word['audio'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
