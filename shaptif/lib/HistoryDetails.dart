import 'package:flutter/material.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/finished_training.dart';

import 'db/database_manager.dart';
import 'db/history.dart';

class HistoryDetails extends StatefulWidget {
  final int? ID;
  final int? i;

  const HistoryDetails({
    Key? key,
    required this.ID,
    required this.i,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryDetailsState();
}

class HistoryDetailsState extends State<HistoryDetails> {
  bool _isExpanded = false;
  late List<FinishedTraining> training;
  late List<History> history;
  bool isLoading = false;
  Set<String> uniqueNames = {};

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    setState(() => isLoading = true);

    training = await DatabaseManger.instance.selectAllFinishedTrainings();
    for (FinishedTraining el in training ) {
      await el.initExerciseMap();
    }
    history = await DatabaseManger.instance.selectHistoryByTraining(widget.ID!);

    getUniqueValues();

    setState(() => isLoading = false);
  }

  getUniqueValues(){
    for(History es in history){
      uniqueNames.add(es.exerciseName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: isLoading ? notLoaded() : loaded(),
    );
  }

  ListView loaded(){
    return ListView.builder(
        itemCount: uniqueNames.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, List> mapa = training[widget.i!].exercisesMap;
          return ExpansionTile(
            title: Text('${uniqueNames.elementAt(index)}'),
            maintainState: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
                for(History singleSet in mapa.values.elementAt(index))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Powtórzenia: ${singleSet.repetitions}'),
                      Text('Ciężar: ${singleSet.weight}'),
                    ],
                 )
             ],
          );
        });
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
