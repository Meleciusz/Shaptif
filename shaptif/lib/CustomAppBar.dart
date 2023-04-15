import 'package:flutter/material.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/History.dart';
import 'package:shaptif/Share.dart';
import 'package:shaptif/TrainingList.dart';
import 'package:shaptif/main.dart';

class BasicBottomAppBar extends StatelessWidget {
  const BasicBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.deepPurple,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                tooltip: 'Excercise list',
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const Exercise()),
                      ));
                },
              ),
            ),
            Expanded(
              child: IconButton(
                tooltip: 'Training list',
                icon: const Icon(Icons.sports_gymnastics_rounded),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const TrainingList()),
                      ),
                      ModalRoute.withName("/"));
                },
              ),
            ),
            Expanded(
              child: IconButton(
                tooltip: 'History',
                icon: const Icon(Icons.history_rounded),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const History()),
                      ),
                      ModalRoute.withName("/"));
                },
              ),
            ),
            Expanded(
              child: IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                tooltip: 'Share',
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const Share()),
                      ),
                      ModalRoute.withName("/"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvancedBottomAppBar extends StatelessWidget {
  int index = 0;

  AdvancedBottomAppBar({Key? key, required int index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      items: const [
        BottomNavigationBarItem(
            tooltip: 'Excercise list',
            icon: Icon(Icons.menu_rounded),
            label: 'Exercises',
            backgroundColor: Colors.deepPurple),
        BottomNavigationBarItem(
            tooltip: 'Training list',
            icon: Icon(Icons.sports_gymnastics_rounded),
            label: 'Trainings',
            backgroundColor: Colors.deepPurple),
        BottomNavigationBarItem(
            tooltip: 'History',
            icon: Icon(Icons.history_rounded),
            label: 'History',
            backgroundColor: Colors.deepPurple),
        BottomNavigationBarItem(
            tooltip: 'Settings',
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            backgroundColor: Colors.deepPurple),
        BottomNavigationBarItem(
            tooltip: 'Share',
            icon: Icon(Icons.share_rounded),
            label: 'Share',
            backgroundColor: Colors.deepPurple)
      ],
    );
  }
}
