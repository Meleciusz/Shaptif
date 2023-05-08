import 'package:flutter/material.dart';

class ExerciseWorkoutScreen extends StatefulWidget {
  final String exerciseName;
  final List<dynamic> sets;

  const ExerciseWorkoutScreen({
    Key? key,
    required this.exerciseName,
    required this.sets,
  }) : super(key: key);

  @override
  _ExerciseWorkoutScreenState createState() => _ExerciseWorkoutScreenState();
}

class _ExerciseWorkoutScreenState extends State<ExerciseWorkoutScreen> {
  int _currentSetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentSet = widget.sets[_currentSetIndex];
    final completedSets = widget.sets.where((s) => s.completed).length;
    final totalSets = widget.sets.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
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
              'Reps: ${currentSet.reps}',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 16),
            Text(
              'Weight: ${currentSet.weight} kg',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Mark Set as Completed'),
              onPressed: () {
                setState(() {
                  currentSet.completed = true;
                  _currentSetIndex++;

                  if (_currentSetIndex >= widget.sets.length) {
                    _showWorkoutCompletedDialog();
                  }
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completedSets/$totalSets Sets Completed'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Workout Completed!'),
        content: Text('You have completed all sets for this exercise.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}