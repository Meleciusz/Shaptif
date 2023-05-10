import 'package:flutter/material.dart';
import 'package:shaptif/NewTraining.dart';
import 'package:shaptif/TrainingDetailsView.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise_set.dart';

class TrainingListView extends StatefulWidget {
  const TrainingListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {
  late List<Training> trainings;
  bool isLoading = false;
  bool trainingIsActive = false;
  late int LocalSelectedTrainingID = -1;

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
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewTrainingView()));
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
          color: LocalSelectedTrainingID == trainings[index].id! &&
                  trainingIsActive
              ? Colors.green[300]
              : Colors.black38,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          child: InkWell(
            onTap: () {
              setState(() {
                LocalSelectedTrainingID = trainings[index].id!;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingDetailsView(
                    training: trainings[index],
                  ),
                ),
              ).then((value) {
                // value to tablica zwróconych wartości z ekranu TrainingDetailsView
                if (value != null) {
                  setState(() {
                    // odczytaj wartości zwrócone z ekranu TrainingDetailsView
                    trainingIsActive = value[0];
                    LocalSelectedTrainingID = value[1];
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
