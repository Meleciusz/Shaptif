import 'package:flutter/material.dart';
import 'package:shaptif/db/exercise.dart';
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
  late List<Exercise> exercise;
  bool isLoading = false;
  Map<int, String> uniqueNames = {};

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

    exercise = await DatabaseManger.instance.selectAllExercises();

    getUniqueValues();

    //training.elementAt(1).

    setState(() => isLoading = false);
  }

  getUniqueValues(){
    for(History es in history){
      uniqueNames.putIfAbsent(es.exerciseID, () => es.exerciseName!);
    }
  }

  Map<int, IconData> iconsMap = {
    1 : Icons.person ,
    5 : Icons.front_hand_outlined ,
    2 : Icons.person ,
    3 : Icons.person ,
    4 : Icons.airline_seat_legroom_extra ,
    6 : Icons.person ,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
      ),
      body: isLoading ? notLoaded() : loaded(),
    );
  }

  ListView loaded(){
    return ListView.builder(
        itemCount: uniqueNames.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, List> mapa = training[widget.i!].exercisesMap;
          return Padding(padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            trailing: Icon(iconsMap.values.elementAt(exercise.elementAt(uniqueNames.keys.elementAt(index)-1).bodyPart-1)),
            title: Text('${uniqueNames.values.elementAt(index)}',
              style: TextStyle(
                fontFamily: 'Audiowide',
                fontSize: 17,
              ),
            ),
            maintainState: true,
            backgroundColor: Color.fromARGB(255, 76, 86, 74),
            collapsedBackgroundColor: Color.fromARGB(255, 51, 50, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
              for(History singleSet in mapa.values.elementAt(index))
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 22,),
                          Text('Powtórzenia: ${singleSet.repetitions}',
                            style: TextStyle(
                              fontFamily: 'Audiowide',
                              fontSize: 13,
                            ),),
                          SizedBox(width: 10,),
                          Text('Ciężar: ${singleSet.weight}',
                            style: TextStyle(
                              fontFamily: 'Audiowide',
                              fontSize: 13,
                            ),),
                          SizedBox(height: 10,),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Divider(
                            color: Colors.white,
                            indent: 20,
                            thickness: 1.0,
                          ),
                        ),
                      )
                    ],
                  )
            ],
          ),
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
