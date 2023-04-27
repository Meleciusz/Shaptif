import 'package:flutter/material.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/set.dart';

class TrainingListView extends StatefulWidget {
  const TrainingListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {

  late List<Training> trainings;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }
  Future _getData() async {
    setState(() => isLoading = true);
    trainings = await DatabaseManger.instance.selectAllTrainings();
    for(var el in trainings)
    {
      await el.initExerciseMap();
      // for(var s in el.sets)
      //   {
      //     await s.getExcerciseName();
      //   }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 171, 171, 222),
      body: isLoading ? notLoaded() :
      loaded(),
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
  ListView loaded()
  {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, List<MySet>> mapa = trainings[index].exercisesMap;
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            child: ListTile(
              title: Text(trainings[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(trainings[index].description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  for (String klucz in mapa.keys)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(klucz, style: TextStyle(fontWeight: FontWeight.bold)),
                        for (MySet singleSet in mapa[klucz]!)
                          Text("Powtórzenia: ${singleSet.repetitions}" + " Ciężar: ${singleSet.weight}"),
                        SizedBox(height: 8),
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
  Text notLoaded()
  {
    return const Text("ładuje sie",
      style: TextStyle(
          fontFamily: 'Audiowide',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    );
  }
}

