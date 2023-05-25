import 'package:flutter/material.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/history.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/ExerciseWorkoutScreen.dart';
import 'package:tuple/tuple.dart';

class TrainingDetailsView extends StatefulWidget {
  final Training training;
  FinishedTraining? finishedTraining;
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
  late bool databaseReloadNeeded = false;
  late bool _isEdited;
  @override
  void initState() {
    _isEdited = false ;
    databaseReloadNeeded=false;
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
                  onEditWorkout:(value)
                  {
                    setState(() {
                      _isEdited = value;
                    });
                  },
                onWorkoutExitEvent: (exerciseSet) async {

                  var setsDoneAndSavedCount = 0;
                  var setsDoneCount = 0;
                  for (History set in widget.finishedTraining!.sets) {
                    if (set.exerciseID == exerciseSet.first.exerciseID)
                      setsDoneAndSavedCount++;
                  }
                  for (ExerciseSet exSet in exerciseSet) {
                    if (exSet.completed) {
                      setsDoneCount++;
                      if (setsDoneCount > setsDoneAndSavedCount) {
                        addHistoryEntry(exSet);
                        updateDatabase(exSet);
                      }
                    }
                  }
                  setState(() {});
                },
                onTrainingStartedEvent: (value) async {
                  bool started = value.item1;
                  bool changed = value.item2;
                  if (started == true) {
                    if (widget.finishedTraining?.id == null) {
                      widget.finishedTraining = (await DatabaseManger.instance
                              .insert(FinishedTraining(
                                  name: widget.training.name,
                                  description: widget.training.description,
                                  finishedDateTime: DateTime.now())))
                          as FinishedTraining;
                    }
                    else if(changed)
                      {

                        print(widget.finishedTraining!.name);
                        changeCurrentTrainingWithSaving();
                        widget.finishedTraining = (await DatabaseManger.instance
                            .insert(FinishedTraining(
                            name: widget.training.name,
                            description: widget.training.description,
                            finishedDateTime: DateTime.now())))
                        as FinishedTraining;
                        print(widget.finishedTraining!.name);
                      }
                  }

                  setState(() {
                    widget.trainingStarted = started;
                    trainingIdChanged = started;
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
            iconSize: 40,
            color: Colors.green,
            onPressed: () {
              backToTrainingListView();

            },
          ),
          IconButton(
            icon: Icon(Icons.add_box_rounded),
            iconSize: 40,
            color: Colors.green,
            onPressed: () {
              // TODO: Implement adding a new exercise
            },
          ),
          IconButton(//Finish current training
            icon: Icon(Icons.fact_check_outlined),
            color: widget.trainingStarted ? Colors.green : (_isEdited==true ? Colors.green : Colors.grey),
            iconSize: 40,
            onPressed: () async {
              if (widget.trainingStarted || _isEdited) await saveTraining();
            },
          ),
          IconButton(
            icon: Icon(Icons.save_rounded),
            iconSize: 40,
            color: Colors.yellow,
            onPressed: () {
              // TODO: Implement saving changes
            },
          ),
        ],
      ),
    );
  }

  Future saveToDatabase() async {
    // TODO: FIX THIS BULLCRAP
    bool found = false;
    var setsInDatabase = await DatabaseManger.instance.selectSetsByTraining(widget.training.id!);

    for (var set in setsInDatabase) {
      for (var key in widget.training.exercisesMap.keys) {
        var exerciseSets = widget.training.exercisesMap[key]!;

        for (var currentSet in exerciseSets) {
          if (currentSet.id == null) {
            continue;
          } else if (set.id! == currentSet.id!) {
            found = true;
            break;
          }
        }

        if (!found) {
           await DatabaseManger.instance.delete(set);
        }
        found = false;
      }
    }
  }
  Future changeCurrentTrainingWithSaving()async
  {
      await saveToDatabase();
      databaseReloadNeeded = true;
      trainingIdChanged = true;
      widget.trainingStarted = true;
  }
  Future saveTraining() async{
    await saveToDatabase();
    databaseReloadNeeded = true;
    trainingIdChanged = false;
    widget.trainingStarted = false;
    backToTrainingListView();
  }

  void addHistoryEntry(ExerciseSet exSet) {
    widget.finishedTraining!.sets.add(History(
        trainingID: widget.finishedTraining!.id!,
        exerciseID: exSet.exerciseID,
        repetitions: exSet.repetitions,
        weight: exSet.weight));
  }

  Future updateDatabase(ExerciseSet exSet) async {
    await DatabaseManger.instance
        .insert(widget.finishedTraining!.sets.last as History);
    if (exSet.id != null)
      await DatabaseManger.instance.update(exSet);
    else
      await DatabaseManger.instance.insert(exSet);
  }

  void backToTrainingListView() {
    Navigator.pop(context, [
      widget.trainingStarted,
      trainingIdChanged ? widget.training.id :  -1,
      widget.finishedTraining,
      databaseReloadNeeded
    ]);
  }
}

class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  List<ExerciseSet> sets;
  bool trainingStarted;
  bool isCurrentTraining;
  final ValueChanged<Tuple2<bool, bool>> onTrainingStartedEvent;
  final ValueChanged<List<ExerciseSet>> onWorkoutExitEvent;
  final ValueChanged<bool> onEditWorkout;

  ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.sets,
    required this.trainingStarted,
    required this.isCurrentTraining,
    required this.onTrainingStartedEvent,
    required this.onWorkoutExitEvent,
    required this.onEditWorkout,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  List<ExerciseSet> backupSets = [];
  late int _completedSets;
  late int _maxSets = widget.sets.length;
  bool _workoutCompleted = false;

  @override
  void initState() {
    super.initState();
    backupSets = widget.sets.toList();
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
                    if (_maxSets > 1 && _maxSets > _completedSets)
                      _removeLastSet();
                      widget.onEditWorkout(true);
                  });
                },
                child: Text('Usuń serię'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _addNewSet();
                    widget.onEditWorkout(true);
                  });
                },
                child: Text('Dodaj serię'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
              backgroundColor: _workoutCompleted ? Colors.grey : Colors.green,
              shape: CircleBorder(),
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewSet() {
    int currentNumberOfSets = widget.sets.length;
    int startingNumberOfSets = backupSets.length;

    if (currentNumberOfSets < startingNumberOfSets) {
      widget.sets.add(ExerciseSet(
        trainingID: widget.sets[currentNumberOfSets].trainingID,
        exerciseID: widget.sets[currentNumberOfSets].exerciseID,
        weight: widget.sets[currentNumberOfSets].weight,
        repetitions: widget.sets[currentNumberOfSets].repetitions,
      ));
    } else {
      widget.sets.add(ExerciseSet(
        trainingID: widget.sets.last.trainingID,
        exerciseID: widget.sets.last.exerciseID,
        weight: widget.sets.last.weight,
        repetitions: widget.sets.last.repetitions,
      ));
    }
    _maxSets++;
  }

  void _removeLastSet() {
    widget.sets.removeLast();
    _maxSets--;
  }

  void _canStartExercise() async {
    _workoutCompleted = false;
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
      if (shouldStartNewTraining) {
        widget.onTrainingStartedEvent(Tuple2(true, true));
        widget.isCurrentTraining = true;
        widget.trainingStarted = true;
        final List<ExerciseSet> returnedSets = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseWorkoutScreen(
              exerciseName: widget.exerciseName,
              sets: widget.sets,
            ),
          ),
        );
        if (returnedSets != null) {
          setState(() {
            widget.sets = returnedSets.toList();
            widget.onWorkoutExitEvent(widget.sets);
            _completedSets = widget.sets.where((s) => s.completed).length;
          });
        }
      }
    } else {
      widget.onTrainingStartedEvent(Tuple2(true, false));
      widget.isCurrentTraining = true;
      widget.trainingStarted = true;
      final List<ExerciseSet> returnedSets = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseWorkoutScreen(
            exerciseName: widget.exerciseName,
            sets: widget.sets,
          ),
        ),
      );
      if (returnedSets != null) {
        setState(() {
          widget.sets = returnedSets.toList();
          widget.onWorkoutExitEvent(widget.sets);
          _completedSets = widget.sets.where((s) => s.completed).length;
        });
      }
    }
  }
}
