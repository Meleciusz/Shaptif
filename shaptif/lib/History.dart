import 'package:flutter/material.dart';
import 'package:shaptif/HistoryDetails.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/history.dart';

import 'db/database_manager.dart';
//TODO: Poprawne wyświetlanie historii (Nazwa / data reningu)
//TODO:Przejście do nowego ekrau i okodowanie go

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  late List<FinishedTraining> trainings;
  bool isLoading = false;
  int ?ID = null;
  int ?i= null;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    setState(() => isLoading = true);
    trainings = await DatabaseManger.instance.selectAllFinishedTrainings();
    for (FinishedTraining el in trainings) {
      await el.initExerciseMap();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: isLoading ? notLoaded() : loaded(),
    );
  }

  ListView loaded() {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (BuildContext context, int index) {
        //Map<String, List> mapa = trainings[0].exercisesMap;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          child: GestureDetector(
            onTap: (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => HistoryDetails(
                      ID: trainings[index].id,
                      i: index
                    )));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Text(
                      trainings[index].name,
                      style: TextStyle(
                          fontFamily: 'Audiowide',
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  SizedBox(height: 8),
                  Text(trainings[index].description,
                      style: TextStyle(
                          fontFamily: 'Audiowide',
                          fontSize: 10)),
                  SizedBox(height: 16),
                  Text(trainings[index].finishedDateTime.toString(),
                      style: TextStyle(
                          fontFamily: 'Audiowide',
                          fontSize: 17)),
                  // for (String klucz in mapa.keys)
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(klucz,
                  //           style: TextStyle(fontWeight: FontWeight.bold)),
                  //       SizedBox(height: 8),
                  //       for (History singleSet in mapa[klucz]!)
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("Powtórzenia: ${singleSet.repetitions}",
                  //                 style: TextStyle(fontSize: 16)),
                  //             Text("Ciężar: ${singleSet.weight}",
                  //                 style: TextStyle(fontSize: 16)),
                  //           ],
                  //         ),
                  //       SizedBox(height: 16),
                  //     ],
                  //   ),
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
