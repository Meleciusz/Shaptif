import 'package:flutter/material.dart';
import 'package:shaptif/db/exercise_set.dart';

class ExerciseWorkoutScreen extends StatefulWidget {
  final String exerciseName;
  final List<ExerciseSet> sets;

  const ExerciseWorkoutScreen({
    Key? key,
    required this.exerciseName,
    required this.sets,
  }) : super(key: key);

  @override
  _ExerciseWorkoutScreenState createState() => _ExerciseWorkoutScreenState();
}

class _ExerciseWorkoutScreenState extends State<ExerciseWorkoutScreen> {
  late int _currentSetIndex;
  int _repetitions = 0;
  double _weight = 0.0;

  @override
  void initState() {
    super.initState();
    _prepareNextSet();
  }

  void _updateCurrentSet() {
    widget.sets[_currentSetIndex].completed = true;
    widget.sets[_currentSetIndex].repetitions = _repetitions ;
    widget.sets[_currentSetIndex].weight = _weight ;
  }

  void _prepareNextSet() {
    _currentSetIndex = widget.sets.where((s) => s.completed).length;

    final currentSet = widget.sets[_currentSetIndex];
    _repetitions = currentSet.repetitions;
    _weight = currentSet.weight;
  }


  void _updateSetsList() {
    setState(() {
      _updateCurrentSet();
    });
    Navigator.pop(context, widget.sets);
  }

  @override
  Widget build(BuildContext context) {
    final currentSet = widget.sets[_currentSetIndex];
    final totalSets = widget.sets.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set ${_currentSetIndex + 1} of $totalSets',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Powtórzenia:',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _repetitions = _repetitions > 0 ? _repetitions - 1 : 0;
                    });
                  },
                ),
                Text(
                  _repetitions.toString(),
                  style: TextStyle(fontSize: 36),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _repetitions++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Ciężar:',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _weight = _weight > 0 ? _weight - 1.0 : 0.0;
                    });
                  },
                ),
                Text(
                  _weight.toString(),
                  style: TextStyle(fontSize: 36),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _weight += 1.0;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text(
                _currentSetIndex == totalSets - 1 ? 'Zakończ ćwiczenie' : 'Kolejna seria',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                setState(() {
                  if (_currentSetIndex < totalSets - 1) {
                    _updateCurrentSet();
                    _prepareNextSet();
                  } else {
                    _updateSetsList();
                  }
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
              FloatingActionButton(
                heroTag: "returnFromWorkout",
                onPressed: () {
                  Navigator.pop(context, widget.sets);
                },
                backgroundColor: const Color.fromARGB(255, 58, 183, 89),
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_back),
        ),
    );
  }
}
