import 'package:flutter/material.dart';
import 'basic_words_page.dart';

final wordParts = [
  {
    'part': 'Part 1',
    'categories': [
      {'title': 'Basic Words', 'slug': 'basic'},
      {'title': 'Numbers and Units', 'slug': 'numbers_units'},
      {'title': 'Date and Time', 'slug': 'date_time'},
      {'title': 'Actions', 'slug': 'actions'},
      {'title': 'Figurative Words', 'slug': 'figurative'},
      {'title': 'Eat and Drink', 'slug': 'eat_drink'},
      {'title': 'Locations (Vietnam)', 'slug': 'locations_vietnam'},
      {'title': 'Locations (Thailand)', 'slug': 'locations_thailand'},
      {'title': 'Locations (Other)', 'slug': 'locations_other'},
      {'title': 'Body', 'slug': 'body'},
    ]
  },
  {
    'part': 'Part 2',
    'categories': [
      {'title': 'Animals and Nature', 'slug': 'animals_nature'},
      {'title': 'Places', 'slug': 'places'},
      {'title': 'Family', 'slug': 'family'},
      {'title': 'Name', 'slug': 'name'},
      {'title': 'Occupation', 'slug': 'occupation'},
      {'title': 'Person\'s Name', 'slug': 'persons_name'},
      {'title': 'Japanese Surname', 'slug': 'japanese_surname'},
      {'title': 'Clothing', 'slug': 'clothing'},
      {'title': 'Room & Equipment', 'slug': 'room_equipment'},
      {'title': 'Daily Necessities', 'slug': 'daily_necessities'},
    ]
  },
  {
    'part': 'Part 3',
    'categories': [
      {'title': 'Colors & Patterns', 'slug': 'colors_patterns'},
      {'title': 'Traffic', 'slug': 'traffic'},
      {'title': 'Direction', 'slug': 'direction'},
      {'title': 'Sports', 'slug': 'sports'},
      {'title': 'Recreation', 'slug': 'recreation'},
      {'title': 'Society', 'slug': 'society'},
      {'title': 'Life', 'slug': 'life'},
      {'title': 'Various Names', 'slug': 'various_names'},
      {'title': 'Trouble', 'slug': 'trouble'},
      {'title': 'Other', 'slug': 'other'},
    ]
  },
];

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  int selectedPartIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedPart = wordParts[selectedPartIndex];
    final categories = selectedPart['categories'] as List<Map<String, String>>;

    return Scaffold(
      appBar: AppBar(title: const Text('Words')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: wordParts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(wordParts[index]['part'] as String),
                    selected: selectedPartIndex == index,
                    onSelected: (_) {
                      setState(() {
                        selectedPartIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    if (category['slug'] == 'basic') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BasicWordsPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${category['title']} is not yet available.'),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 2,
                    child: Center(
                      child: Text(
                        category['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
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
