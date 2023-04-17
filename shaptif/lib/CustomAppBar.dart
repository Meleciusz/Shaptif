import 'package:flutter/material.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/History.dart';
import 'package:shaptif/Share.dart';
import 'package:shaptif/TrainingList.dart';

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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const ExcerciseView()),
                      ),
                      ModalRoute.withName("/"));
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
                        builder: ((context) => const TrainingListView()),
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
                        builder: ((context) => const HistoryView()),
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
                        builder: ((context) => const ShareView()),
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
