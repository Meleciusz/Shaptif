import 'package:flutter/material.dart';
//import 'DarkThemeProvider.dart';
import 'package:shaptif/TrainingBuilder.dart';


class NewTrainingView extends StatefulWidget {
  const NewTrainingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<NewTrainingView> {
  //DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState(){
    super.initState();
    //getCurrentAppTheme();
  }

  // void getCurrentAppTheme() async {
  //   themeChangeProvider.darkTheme =
  //   await themeChangeProvider.darkThemePreference.getTheme();
  // }
  Set<String> exercises = {};

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery. of(context). size. height;
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Nadaj nazwe'),
                      content: TextField(
                        onChanged: (value){
                          setState(() {

                          });
                        },
                        decoration:  InputDecoration(hintText: 'Nazwa treningu'),
                      ),
                        //content: ,
                        actions: <Widget>[
                          TextButton(
                              onPressed: (){Navigator.pop(context, 'OK');},
                              child: const Text('OK'))
                        ],
                    )
                    );
              },
            shape: CircleBorder(),
            backgroundColor: Colors.orangeAccent,
            child: Icon(Icons.save),
          )
        ],
      )
  );

  }

  // Widget showDialogAlert(BuildContext context) {
  //   return
  // }


}
