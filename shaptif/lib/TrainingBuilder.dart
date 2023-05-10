import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DarkThemeProvider.dart';
import 'SharedPreferences.dart';
import 'db/database_manager.dart';
import 'db/exercise.dart';

class TrainingBuilder extends StatefulWidget {
  const TrainingBuilder({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<TrainingBuilder> {
  @override
  void initState(){
    super.initState();
    refreshExercises();
  }

  late List<Exercise> exercises;
  bool isLoading = false;

  Future refreshExercises() async {
    setState(() => isLoading = true);

    exercises = await DatabaseManger.instance.selectAllExercises();
    if (exercises.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true)
      {
        await DatabaseManger.instance.initialData();
        exercises = await DatabaseManger.instance.selectAllExercises();
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    double heigth = MediaQuery. of(context). size. height;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: isLoading ? buildProgressIndicator(context) : ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text('${exercises[index].name}'),
                onTap: (){
                },
              );
            }),
        drawer: Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: heigth/10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Icon(
                        Icons.filter_list
                    )
                  ],
                ),
                SizedBox(
                  height: heigth/10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTab(Icons.back_hand, 'Ręce'),
                    buildTab(Icons.airline_seat_legroom_reduced_rounded, 'Nogi'),
                    buildTab(Icons.person, 'Klata'),
                    buildTab(Icons.person, 'Plecy'),
                    buildTab(Icons.person, 'Brzuch'),
                    buildTab(Icons.person, 'Barki'),
                  ],
                ),
              ],
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          shape: const CircleBorder(),
          child: const Icon(Icons.keyboard_backspace),
        ),
      ),
    );
  }

  IconButton buildTab(IconData icon, String text) {
    return IconButton(
      icon: Icon(icon),
      onPressed: (){
        setState(() {

        });
      },
    );
  }

  Widget buildProgressIndicator(BuildContext context) {
    return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.green,
        ) //Color of indicator
    );
  }
}
