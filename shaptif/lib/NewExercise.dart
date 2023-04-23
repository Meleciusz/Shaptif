import 'package:flutter/material.dart';
//TODO Maksymalna liczba znaków w nazwie ćwiczenia
class NewExercise extends StatefulWidget {
  const NewExercise({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewExerciseViewState();
}

class NewExerciseViewState extends State<NewExercise> {
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
                children: const <Widget>[

                  TextField(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
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

                  SizedBox(
                      height: 50
                  ),

                  TextField(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
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
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: const Color.fromARGB(255, 166, 16, 16),
                shape: const CircleBorder(),
                child: const Icon(Icons.keyboard_backspace),
              ),
                SizedBox(width: 40,),

                FloatingActionButton (
                onPressed: () {

                },
                backgroundColor: const Color.fromARGB(255, 95, 166, 83),
                shape: const CircleBorder(),
                child: const Icon(Icons.save),
              ),
          ]));

  }
}
