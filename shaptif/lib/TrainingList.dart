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
      await el.getSets();
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
      itemBuilder: (context, index) {
        final training = trainings[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(training.name),
              subtitle: Text(training.description),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: training.sets.length,
              itemBuilder: (context, index) {
                final set = training.sets[index];
                return ListTile(
                  title: Text('ćwiczonko ${ set.excerciseName}'),
                  subtitle: Text('Reps: ${(set).repetitions}, Weight: ${(set).weight}'),
                );
              },
            ),
          ],
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

