import 'package:flutter/material.dart';
import 'package:shaptif/db/body_part.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise.dart';

import 'db/setup.dart';

class NewExercise extends StatefulWidget {
  NewExercise({required this.exercises, Key? key}) : super(key: key);
  List<Exercise> exercises;
  @override
  State<StatefulWidget> createState() => NewExerciseViewState();
}

class NewExerciseViewState extends State<NewExercise> {
  late Map<String,bool> images = Map.fromIterable(
    BodyPartImages.names,
    key: (str) => str,
    value: (str) => false,
  );

  int selectedBodyPart = 1;
  late List<BodyPart> bodyParts;
  late List<DropdownMenuItem<int>> items;

  bool isLoading = false;
  final exerciseNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadButtonList();
  }

  Future loadToDataBase() async {
    setState(() => isLoading = true);
    Exercise newExcercise = await DatabaseManger.instance.insert(Exercise(
        name: exerciseNameController.text,
        description: descriptionController.text,
        bodyPart: selectedBodyPart,
        isEmbedded: false)) as Exercise;

    newExcercise.bodyPartString =
        (await DatabaseManger.instance.selectBodyPart(selectedBodyPart)).name;

    widget.exercises.add(newExcercise);

    Navigator.of(context).pop();
  }

  Future loadButtonList() async {
    setState(() => isLoading = true);

    bodyParts = await DatabaseManger.instance.selectAllBodyParts();

    items = bodyParts.map((bodyPart) {
      return DropdownMenuItem<int>(
        value: bodyPart.id,
        child: Text(bodyPart.name),
      );
    }).toList();

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    exerciseNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; //screen width
    double height = MediaQuery.of(context).size.height; //screen height
    String appBarText = 'Nowe ćwiczenie';

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            centerTitle: true,
            title: Text(
              appBarText,
              style: const TextStyle(
                  fontFamily: 'Audiowide',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            backgroundColor: const Color.fromARGB(255, 31, 31, 33),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                side: BorderSide(
                  width: 1,
                  color: Colors.black,
                  //style: BorderStyle.none
                )),
            automaticallyImplyLeading: false,
          ),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  for(var key in images.keys)
                  ColorFiltered(

                    //colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcATop),
                    colorFilter: images[key]! ? const ColorFilter.mode(Colors.red, BlendMode.srcATop) : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
                    child: Image.asset(
                      "images/body_parts/"+key+".png",
                      fit: BoxFit.contain,
                      height: 250,
                    ),
                  ),
                ],
              ),
              for (String item in BodyPartImages.names)
                CheckboxListTile(
                  title: Text(item),
                  value: images[item] ?? false, onChanged: (bool? value) {
                  setState(() {
                    images[item] = value ?? false;
                  });
                },
                ),
              TextField(
                controller: exerciseNameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                    labelText: 'Wpisz nazwe ćwiczenia',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 92, 92, 94)),
                    enabledBorder: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 92, 92, 94), width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 92, 92, 94), width: 3),
                    )),
                maxLength: 20,
                maxLines: 1,
              ),
              const SizedBox(height: 50),
              isLoading
                  ? buildProgressIndicator(context)
                  : DropdownButton<int>(
                      icon: const Icon(Icons.arrow_downward),
                      value: selectedBodyPart,
                      onChanged: (int? value) {
                        setState(() {
                          selectedBodyPart = value!;
                          //dropdownValueController = list.indexOf(value!);
                        });
                      },
                      items: items,
                    ),
              const SizedBox(height: 50),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                    labelText: 'Opis',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 92, 92, 94)),
                    enabledBorder: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 92, 92, 94), width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 92, 92, 94), width: 3),
                    )),
                maxLines: 10,
              ),
            ],
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "ReturnButton",
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color.fromARGB(255, 166, 16, 16),
            shape: const CircleBorder(),
            child: const Icon(Icons.keyboard_backspace),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            heroTag: "SaveExerciseButton",
            onPressed: () {
              loadToDataBase();
            },
            backgroundColor: const Color.fromARGB(255, 95, 166, 83),
            shape: const CircleBorder(),
            child: const Icon(Icons.save),
          ),
        ]));
  }

  Widget buildProgressIndicator(BuildContext context) {
    return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
      Colors.black,
    ) //Color of indicator
        );
  }
}
