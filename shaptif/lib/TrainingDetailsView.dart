import 'package:flutter/material.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/ExerciseWorkoutScreen.dart';

class TrainingDetailsView extends StatefulWidget {
  final Training training;

  TrainingDetailsView({required this.training});

  @override
  _TrainingDetailsViewState createState() => _TrainingDetailsViewState();
}

class _TrainingDetailsViewState extends State<TrainingDetailsView> {
  bool _trainingStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.training.description),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.training.exercisesMap.length,
              itemBuilder: (context, index) {
                final exerciseName =
                widget.training.exercisesMap.keys.elementAt(index);
                final sets = widget.training.exercisesMap[exerciseName]!;
                return ExerciseTile(
                  exerciseName: exerciseName,
                  sets: sets,
                  onWorkoutStarted: () {
                    setState(() {
                      _trainingStarted = true;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Implement adding a new exercise
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // TODO: Implement saving changes
            },
          ),
        ],
      ),
    );
  }
}
class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  final List<dynamic> sets;
  final VoidCallback onWorkoutStarted;

  const ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.sets,
    required this.onWorkoutStarted,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late int  _completedSets = widget.sets.where((s) => s.completed).length;
  late int _maxSets =widget.sets.length;
  bool _workoutCompleted = false;

  @override
  void initState() {
    super.initState();
    _completedSets = 0; // TODO: Implement Loading number of done sets
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.exerciseName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _completedSets.toString() + "/" + _maxSets.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    final maxSets = widget.sets.length;
    final canStartWorkout = _completedSets < maxSets;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                    setState(() {
                      _maxSets>1 && _maxSets>_completedSets ? _maxSets--:_maxSets;
                    });
                },
                child: Text('Usuń serię'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _maxSets++;
                  });
                },
                child: Text('Dodaj serię'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: canStartWorkout
                ? () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExerciseWorkoutScreen(
                    exerciseName: widget.exerciseName,
                    sets: widget.sets),
              ));
            }
                : null,
            child: Icon(Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              primary: _workoutCompleted ? Colors.grey : Colors.green,
              shape: CircleBorder(),
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}

