import 'package:flutter/material.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/ExerciseWorkoutScreen.dart';

class TrainingDetailsView extends StatefulWidget {
  final Training training;
  final FinishedTraining? finishedTraining;
  final int currentTrainingId;
  bool trainingStarted;
  TrainingDetailsView({
    required this.training,
    required this.finishedTraining,
    required this.trainingStarted,
    required this.currentTrainingId,
  });

  @override
  _TrainingDetailsViewState createState() => _TrainingDetailsViewState();
}

class _TrainingDetailsViewState extends State<TrainingDetailsView> {
  late bool trainingIdChanged = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training.name),
        automaticallyImplyLeading: false,
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
                isCurrentTraining: trainingIdChanged
                    ? true
                    : widget.currentTrainingId == widget.training.id
                        ? true
                        : false,
                trainingStarted: widget.trainingStarted,
                onTrainingStartedChanged: (value) {
                  setState(() {
                    widget.trainingStarted = value;
                  });
                },
                onTrainingStartedIdChanged: (value) {
                  setState(() {
                    trainingIdChanged = value;
                  });
                },
              );
            },
          )),
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
              Navigator.pop(context, [
                widget.trainingStarted,
                trainingIdChanged ? widget.training.id : -1,
                widget.finishedTraining
              ]);
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
  final List<ExerciseSet> sets;
  bool trainingStarted;
  bool isCurrentTraining;
  final ValueChanged<bool> onTrainingStartedChanged;
  final ValueChanged<bool> onTrainingStartedIdChanged;

  ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.sets,
    required this.trainingStarted,
    required this.isCurrentTraining,
    required this.onTrainingStartedChanged,
    required this.onTrainingStartedIdChanged,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  List<ExerciseSet> editableSets = [];
  late int _completedSets;
  late int _maxSets = widget.sets.length;
  bool _workoutCompleted = false;

  @override
  void initState() {
    super.initState();
    editableSets = widget.sets.toList();
    _completedSets = widget.sets.where((s) => s.completed).length;
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
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    final maxSets = editableSets.length;
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
                    if (_maxSets > 1 && _maxSets > _completedSets)
                      _removeLastSet();
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
                    _addNewSet();
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
                    _canStartExercise();
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

  void _addNewSet() {
    int currentNumberOfSets = editableSets.length;
    int startingNumberOfSets = widget.sets.length;

    if (currentNumberOfSets < startingNumberOfSets) {
      editableSets.add(ExerciseSet(
        trainingID: widget.sets[currentNumberOfSets].trainingID,
        exerciseID: widget.sets[currentNumberOfSets].exerciseID,
        weight: widget.sets[currentNumberOfSets].weight,
        repetitions: widget.sets[currentNumberOfSets].repetitions,
      ));
    } else {
      editableSets.add(ExerciseSet(
        trainingID: widget.sets.last.trainingID,
        exerciseID: widget.sets.last.exerciseID,
        weight: widget.sets.last.weight,
        repetitions: widget.sets.last.repetitions,
      ));
    }
    _maxSets++;
  }

  void _removeLastSet() {
    editableSets.removeLast();
    _maxSets--;
  }

  void _canStartExercise() async {
    _workoutCompleted = false;
    print("training started: " + widget.trainingStarted.toString());
    print("current : " + widget.isCurrentTraining.toString());
    if (widget.trainingStarted && !widget.isCurrentTraining) {
      bool shouldStartNewTraining = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              "Czy na pewno chcesz zakończyć poprzedni trening i rozpocząć ten?"),
          actions: [
            TextButton(
              child: Text("Nie"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text("Tak"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      );
      if (!shouldStartNewTraining) {
        widget.onTrainingStartedIdChanged(false);
        return;
      } else {
        widget.onTrainingStartedChanged(true);
        widget.onTrainingStartedIdChanged(true);
        widget.isCurrentTraining = true;
        widget.trainingStarted = true;
        final List<ExerciseSet> returnedSets = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseWorkoutScreen(
              exerciseName: widget.exerciseName,
              sets: editableSets,
            ),
          ),
        );
        if (returnedSets != null) {
          setState(() {
            editableSets = returnedSets.toList();
            _completedSets = editableSets.where((s) => s.completed).length;
          });
        }
      }
    } else {
      widget.onTrainingStartedChanged(true);
      widget.onTrainingStartedIdChanged(true);
      widget.isCurrentTraining = true;
      widget.trainingStarted = true;
      final List<ExerciseSet> returnedSets = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseWorkoutScreen(
            exerciseName: widget.exerciseName,
            sets: editableSets,
          ),
        ),
      );
      if (returnedSets != null) {
        setState(() {
          editableSets = returnedSets.toList();
          _completedSets = editableSets.where((s) => s.completed).length;
        });
      }
    }
  }
}
