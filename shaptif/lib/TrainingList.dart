import 'package:flutter/material.dart';
import 'package:shaptif/TrainingDetailsView.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/database_manager.dart';

class TrainingListView extends StatefulWidget {
  const TrainingListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {
  late List<Training> trainings;
  bool isLoading = false;
  bool trainingIsActive = false;
  late int localSelectedTrainingID = -1;
  FinishedTraining? finishedTraining = null;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    setState(() => isLoading = true);
    trainings = await DatabaseManger.instance.selectAllTrainings();
    for (Training el in trainings) {
      await el.initExerciseMap();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: isLoading ? notLoaded() : loaded(),
      floatingActionButton: FloatingActionButton(
        heroTag: "AddTrainingButton",
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Smack me!"),
              action: SnackBarAction(
                  label: "Fuck",
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  })));
        },
        backgroundColor: const Color.fromARGB(255, 58, 183, 89),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView loaded() {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: localSelectedTrainingID == trainings[index].id! &&
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
                    training: trainings[index],
                    trainingStarted: trainingIsActive,
                    currentTrainingId:localSelectedTrainingID,
                  ),
                ),
              ).then((value) {
                // value to tablica zwróconych wartości z ekranu TrainingDetailsView
                if (value != null) {
                  setState(() {
                    // odczytaj wartości zwrócone z ekranu TrainingDetailsView
                    trainingIsActive = value[0];
                    if(value[1]>=0)
                      localSelectedTrainingID = value[1];
                    finishedTraining = value[2];
                    bool databaseReloadNeeded = value[3];
                    if(databaseReloadNeeded)

                      _getData();
                  });
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
                      Text(trainings[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 8),
                      Text(trainings[index].description),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          ),
        );
      },
    );
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
