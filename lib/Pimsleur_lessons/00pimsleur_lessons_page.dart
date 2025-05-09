import 'package:flutter/material.dart';
import 'pimsleur_lesson01.dart';
import 'pimsleur_lesson02.dart';

class PimsleurLessonsPage extends StatelessWidget {
  const PimsleurLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pimsleur Anki Vocabulary')),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          final lessonNumber = index + 1;
          return Card(
            child: ListTile(
              title: Text('Lesson ${lessonNumber.toString().padLeft(2, '0')}'),
              subtitle: const Text('Vocab + Audio'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (lessonNumber == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PimsleurLesson01()),
                  );
                } else if (lessonNumber == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PimsleurLesson02()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lesson $lessonNumber not implemented yet.')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
