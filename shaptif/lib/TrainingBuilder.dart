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
  TextEditingController editingController = TextEditingController();
  @override
  void initState(){
    super.initState();
    refreshExercises();
  }

  late List<Exercise> exercises;
  late List<bool> standardSelectIndex;
  Map<String, List<Exercise>> filteredExercises = {};
  late var items = <Exercise>[];
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


    await initExerciseMap();
    items = exercises;
    setState(() => isLoading = false);
  }

  int ?selectedIndex;
  int selectedKey = 0;

  Map<String, IconData> iconsMap = {
    'Plecy' : Icons.person ,
    'Ręce' : Icons.front_hand_outlined ,
    'Klata' : Icons.person ,
    'Barki' : Icons.person ,
    'Nogi' : Icons.airline_seat_legroom_extra ,
    'Brzuch' : Icons.person ,
  };

  String ?selectedIconKey;
  late String choosenExercise;// = exercises[selectedIndex].name;

  void filterSearchResults(value) {
    setState(() {
      items = exercises
          .where((item) => item.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    double heigth = MediaQuery. of(context). size. height;
      return Scaffold(
          appBar: AppBar(
            title: Text('Filters'),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value){
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular((25.0)))
                        )
                      ),
                    ),
                ),
                Expanded(
                    child: isLoading ? buildProgressIndicator(context) : ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${items[index].name}'),
                          selectedTileColor: Colors.green,
                          selected: index == selectedIndex,
                          splashColor: Colors.green,
                          onTap: (){
                            setState(() {
                              selectedIndex = index;
                            });
                            choosenExercise = items[index].name;
                          },
                        );
                      },
                    ),
                )
              ],
            ),
          ),
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
                        items = filteredExercises.values.elementAt(kaka);
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
