import 'package:flutter/material.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise.dart';

import 'db/setup.dart';

class Description extends StatefulWidget {
  final Exercise exercise;
  final List<Exercise> exercises;
  const Description({Key? key, required this.exercise, required this.exercises}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DescriptionViewState( );
}


class DescriptionViewState extends State<Description>{
  late Map<String, bool> images;
  bool canBeDeleted = false;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    getCanBeDeleted();
    images = imageHashToMap(widget.exercise.imageHash);
  }

Future getCanBeDeleted() async {
  setState(() => isLoading = true);
  canBeDeleted = await widget.exercise.canBeDeleted();
  setState(() => isLoading = false);
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          centerTitle: true,
          title: Text(
            widget.exercise.name, //Maksimum 20 znaków
            style: const TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          backgroundColor: const Color.fromARGB(255, 31, 31, 33),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)
              ),
              side: BorderSide(
                width: 1,
                color: Colors.black,
                //style: BorderStyle.none
              )
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  for (var key in images.keys)
                    ColorFiltered(
                      colorFilter: images[key]!
                          ? const ColorFilter.mode(
                          Colors.red, BlendMode.srcATop)
                          : const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcATop),
                      child: Image.asset(
                        "images/body_parts/" + key + ".png",
                        fit: BoxFit.contain,
                        height: 250,
                      ),
                    ),
                ],
              ),
              if(!isLoading && canBeDeleted)
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Usuwanie ćwiczenia"),
                        content: Text(
                            "Czy na pewno chcesz usunąć ćwiczenie " +
                                //exercise.name +
                                " ?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Anuluj"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              deleteExercise();
                             // Fluttertoast.showToast(
                                 // msg: "Usunięto "
                                //+ exercise.name.toLowerCase(),
                              //);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 32.0,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grupa mięśniowa: ',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                      ),
                  Text(
                    widget.exercise.bodyPartString!,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
              const SizedBox(
                height: 24.0),
                Text(
                'Opis:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Text(
                  widget.exercise.description,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
            heroTag: "ReturnButton",
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color.fromARGB(255, 166, 16, 16),
            shape: const CircleBorder(),
            child: const Icon(Icons.keyboard_backspace),
          ),
      );
  }
  Map<String, bool> imageHashToMap(int hash)
  {
    int index = BodyPartImages.names.length-1;
    String binaryString = hash.toRadixString(2).padLeft(BodyPartImages.names.length, '0');
    return Map.fromIterable(
      BodyPartImages.names,
      key: (str) => str,
      value: (str) =>  binaryString[index--] == '1' ? true:false,
    );
  }
  Future deleteExercise() async {
    setState(() => isLoading = true);
    await DatabaseManger.instance.delete(widget.exercise);

    widget.exercises.removeWhere((element) => element == widget.exercise);

    Navigator.of(context).pop();
  }
}