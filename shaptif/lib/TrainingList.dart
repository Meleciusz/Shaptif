import 'package:flutter/material.dart';

class TrainingListView extends StatefulWidget {
  const TrainingListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: Center(
        child: Column(
            // children: <Widget>[
            //   ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: const Text('cos'),
            //   ),
            // ],
            ),
      ),
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
}
