import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shaptif/NewTraining.dart';
import 'package:shaptif/TrainingDetailsView.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/database_manager.dart';

class TrainingListView extends StatefulWidget {
  final ValueChanged<bool> onTrainingChanged;

  final List<Training> trainings;

  const TrainingListView({    Key? key,
    required this.onTrainingChanged,
    required this.trainings,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {

  bool isLoading = false;
  bool trainingIsActive = false;
  late int localSelectedTrainingID = -1;
  FinishedTraining? finishedTraining = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: isLoading ? notLoaded() : loaded(),
      floatingActionButton: FloatingActionButton(
        heroTag: "AddTrainingButton",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTrainingView())
          ).then((addedSuccessfully) {
            widget.onTrainingChanged(true);
            setState(() {
              widget.trainings;
            });
            if(addedSuccessfully!=null)
              {
                if(addedSuccessfully){
                  Fluttertoast.showToast(
                    msg: "Dodano " + widget.trainings.last.name.toLowerCase(),
                  );
                }
              }
          });},
        backgroundColor: const Color.fromARGB(255, 58, 183, 89),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView loaded() {
    return ListView.builder(
      itemCount: widget.trainings.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: localSelectedTrainingID == widget.trainings[index].id! &&
                  trainingIsActive
              ? Colors.green[300]
              : Colors.black38,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          child: InkWell(
            onTap: () {
              setState(() {
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingDetailsView(
                    finishedTraining: finishedTraining,
                    training: widget.trainings[index],
                    trainingStarted: trainingIsActive,
                    currentTrainingId:localSelectedTrainingID,
                  ),
                ),
              ).then((value) async{
                // value to tablica zwróconych wartości z ekranu TrainingDetailsView
                if (value != null) {
                  trainingIsActive = value[0];
                  if(value[1]>=0)
                    localSelectedTrainingID = value[1];
                  finishedTraining = value[2];
                  bool databaseReloadNeeded = value[3];
                  if(databaseReloadNeeded)
                    widget.onTrainingChanged(true);
                  setState((){});
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.trainings[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 8),
                      Text(widget.trainings[index].description),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _deleteTraining(widget.trainings[index]);
                        },
                        icon: Icon(Icons.delete),
                      ),
                      SizedBox(width: 8), // Odstęp między ikonami
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _deleteTraining(Training training) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Potwierdź usunięcie treningu'),
        content: Text('Czy na pewno chcesz usunąć ten trening?'),
        actions: [
          TextButton(
            child: Text('Anuluj'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text('Usuń'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );

    if (confirmDelete) {
      if(localSelectedTrainingID==training.id!)
        {
          localSelectedTrainingID=-1;
          trainingIsActive = false;
        }
      List<ExerciseSet> exerciseSets = await DatabaseManger.instance.selectSetsByTraining(training.id!);
      for(ExerciseSet set in exerciseSets)
        await DatabaseManger.instance.delete(set);
      int deleteCount = await DatabaseManger.instance.delete(training);
      if (deleteCount > 0) {
        Fluttertoast.showToast(msg: "Usunięto " + training.name.toLowerCase());
        widget.onTrainingChanged(true);
      } else {
        Fluttertoast.showToast(msg: "Błąd podczas usuwania " + training.name.toLowerCase());
      }
    }
  }

  Text notLoaded() {
    return const Text(
      "ładuje sie",
      style: TextStyle(
          fontFamily: 'Audiowide',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    );
  }
}
