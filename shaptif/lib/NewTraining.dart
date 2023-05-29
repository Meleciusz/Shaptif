import 'package:flutter/material.dart';
import 'package:shaptif/TrainingBuilder.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/training.dart';


class NewTrainingView extends StatefulWidget {
  const NewTrainingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<NewTrainingView> {

  bool isLoading = false;
  int weight = 50;
  String trainingName = '';
  String descriptionName = '';
  Set<String> exercises = {};
  @override
  void initState(){
    super.initState();
  }

  Future loadToDatabase() async{
    setState(() => isLoading = true);

    await DatabaseManger.instance.insert(Training(
        name: trainingName,
        description: descriptionName,
        isEmbedded: false));

    // for(String rm in exercises){
    //
    // }
    // await DatabaseManger.instance.insert(ExerciseSet(
    //     trainingID: trainingID,
    //     exerciseID: exerciseID,
    //     repetitions: 5,
    //     weight: 50.0));

    setState(() => isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index){
                  return Card(
                    color: Colors.greenAccent,
                      child:Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: Text('${exercises.elementAt(index)}'),
                          trailing: SizedBox(
                            child: Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.delete),
                                onPressed: (){
                                    setState(() {
                                      exercises.remove(exercises.elementAt(index));
                                    });
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                  );
                }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "AddExercise",
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingBuilderView())
              ).then((value){
                if(value != null){
                  setState(() {
                    exercises.add(value);
                  });
                }
              });
            },
            shape: CircleBorder(),
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
              heroTag: "SaveTraining",
              onPressed: (){
                if(exercises.length > 0){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Nadaj nazwe'),
                        content: Wrap(
                          runSpacing: 8.0,
                            children:[
                              TextField(
                                maxLines : 5,
                                onChanged: (value){
                                  setState(() {
                                    descriptionName = value;
                                  });
                                },
                                decoration:  InputDecoration(
                                    hintText: 'Opis treningu'
                                ),
                              ),
                              TextField(
                                maxLength: 20,
                                onChanged: (value){
                                  setState(() {
                                    trainingName = value;
                                  });
                                },
                                decoration:  InputDecoration(hintText: 'Nazwa treningu'),
                              ),
                            ],
                          ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: (){
                                loadToDatabase();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('OK')
                          )
                        ],
                      )
                  );
                }
                else{
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Trening musi mieć chociaż jedo ćwiczenie!'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text('OK')
                          )
                        ],
                      )
                  );
                }
              },                  //onPressed end
            shape: CircleBorder(),
            backgroundColor: Colors.orangeAccent,
            child: Icon(Icons.save),
          )
        ],
      )
  );

  }


  Widget buildProgressIndicator(BuildContext context) {
    return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.black,) //Color of indicator
    );
  }

}
