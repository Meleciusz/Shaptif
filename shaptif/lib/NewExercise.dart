import 'package:flutter/material.dart';
import 'package:shaptif/db/DatabaseManager.dart';
import 'package:shaptif/db/Category.dart';
import 'package:shaptif/db/Exercise.dart';

class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewExerciseViewState();
}


//   Future refreshExcercises() async {
//     setState(() => isLoading = true);
//
//     excercises = await DatabaseManger.instance.selectAllExcercise();
//     if (excercises.isEmpty) {
//       await DatabaseManger.instance.initialData();
//       excercises = await DatabaseManger.instance.selectAllExcercise();
//     }
//     for (var ex in excercises) {
//       BodyPart c = await DatabaseManger.instance.selectBodyPart(ex.category);
//       ex.categoryS = c.name;
//     }
//     setState(() => isLoading = false);
// }



const List<String> list = <String>['Klacisko', 'Plecory', 'Nygi', 'Cycochy']; String dropdownValue = list.first;
class NewExerciseViewState extends State<NewExercise> {
  bool isLoading = false;
  final  exerciseNameController = TextEditingController();
  var  dropdownValueController = 1;
  final  descriptionController = TextEditingController();

  Future refreshExcercises() async {
    setState(() => isLoading = true);
    await DatabaseManger.instance.insert(Excercise(
        name: exerciseNameController.text,
        description: descriptionController.text,
        category: dropdownValueController));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Dodano do bazy danych! Dobra robota szefie!!"),
    ));
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
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
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
      body: Center(
          child: ListView(
            padding: const EdgeInsets.all(32),
                children: <Widget>[

                    TextField(
                    controller: exerciseNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                      labelText: 'Wpisz nazwe ćwiczenia',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 92, 92, 94)),
                      enabledBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color.fromARGB(255, 92, 92, 94), width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color.fromARGB(255, 92, 92, 94), width: 3),
                      )
                    ),
                    maxLength: 20,
                    maxLines: 1,
                  ),

                  const SizedBox(
                      height: 50
                  ),

                  DropdownButton<String>(
                    icon: const Icon(Icons.arrow_downward),
                    value: dropdownValue,

                    onChanged: (String? value){
                      setState(() {
                        dropdownValue = value!;
                        dropdownValueController = list.indexOf(value!);
                      });
                    },

                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  const SizedBox(
                      height: 50
                  ),

                    TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                        labelText: 'Opis',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 92, 92, 94)),
                        enabledBorder: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Color.fromARGB(255, 92, 92, 94), width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Color.fromARGB(255, 92, 92, 94), width: 3),
                        )
                    ),
                    maxLines: 10,
                  ),

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
                  refreshExcercises();
                },
                backgroundColor: const Color.fromARGB(255, 95, 166, 83),
                shape: const CircleBorder(),
                child: const Icon(Icons.save),
              ),
          ]));

  }
}
