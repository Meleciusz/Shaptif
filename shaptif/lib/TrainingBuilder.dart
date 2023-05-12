import 'package:flutter/material.dart';
import 'package:shaptif/db/body_part.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SharedPreferences.dart';

class TrainingBuilderView extends StatefulWidget {
  const TrainingBuilderView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainingBuilderViewState();
}

class TrainingBuilderViewState extends State<TrainingBuilderView> {
  @override
  void initState(){
    super.initState();
    refreshExercises();

  }


  late List<Exercise> exercises;
  late List<bool> standardSelectIndex;
  Map<String, List<Exercise>> filteredExercises = {};
  bool isLoading = false;

  Future initExerciseMap() async
  {
    for(var s in exercises) {
      if(!filteredExercises.containsKey(s.bodyPartString))
      {
        List<Exercise> tempList = [s];
        filteredExercises[s.bodyPartString!] = tempList;
      }
      else
      {
        filteredExercises[s.bodyPartString]!.add(s);
      }
    }
  }

  Future refreshExercises() async {
    setState(() => isLoading = true);

    exercises = await DatabaseManger.instance.selectAllExercises();
    //bodyParts = await DatabaseManger.instance.selectAllBodyParts();
    if (exercises.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true)
      {
        await DatabaseManger.instance.initialData();
        exercises = await DatabaseManger.instance.selectAllExercises();
      }
    }

    // for(BodyPart bp in bodyParts) {
    //   standardSelectIndex.add(false);
    //   }
    await initExerciseMap();
    setState(() => isLoading = false);
  }

  int selectedIndex = 0;
  int selectedKey = 0;

  Map<String, IconData> iconsMap = {
    'Plecy' : Icons.person ,
    'Klata' : Icons.person ,
    'Barki' : Icons.person ,
    'Nogi' : Icons.airline_seat_legroom_extra ,
    'Ręce' : Icons.front_hand_outlined ,
    'Brzuch' : Icons.person ,
  };

  String ?selectedIconKey;
  String ?choosenExercise;

  @override
  Widget build(BuildContext context) {

    double heigth = MediaQuery. of(context). size. height;
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Filters'),
          ),
          body: isLoading ? buildProgressIndicator(context) : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index){
                return Ink(
                  //color: color,
                  child:   ListTile(
                      title: Text('${exercises[index].name}'),
                      selectedTileColor: Colors.green,
                      selected: index == selectedIndex,
                      splashColor: Colors.green,
                      onTap: (){
                        setState(() {
                          selectedIndex = index;
                        });
                        choosenExercise = exercises[index].name;
                      },
                    )
                );

              }),
          drawer: Drawer(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.filter_list
                      )
                    ],
                  )
                ),
                Divider(),
                ...iconsMap.keys.map((key) {
                  final IconData? iconData = iconsMap[key];
                  final bool isSelected = (key == selectedIconKey);

                  return ListTile(
                    leading: Icon(
                      iconData,
                      color: isSelected ? Colors.blue : null, // Koloruj klikniętą ikonę na niebiesko
                    ),
                    title: Text('$key'),
                    onTap: () {
                      setState(() {
                        selectedIconKey = key; // Ustaw wybrany klucz ikony
                        List<MapEntry<String, IconData>> lista = iconsMap.entries.toList();
                        int kaka = lista.indexWhere((entry) => entry.key == key);
                        exercises = filteredExercises.values.elementAt(kaka);
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton (
                  heroTag: "ReturnButton",
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  backgroundColor: const Color.fromARGB(255, 166, 16, 16),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.keyboard_backspace),
                ),
                const SizedBox(width: 40,),

                FloatingActionButton (
                  heroTag: "SaveExerciseButton",
                  onPressed: () {
                    Navigator.pop(context, choosenExercise);
                  },
                  backgroundColor: const Color.fromARGB(255, 95, 166, 83),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.save),
                ),
              ])
      ),
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
