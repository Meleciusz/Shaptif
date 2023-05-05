import 'package:flutter/material.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise.dart';

class Description extends StatefulWidget {
  final Exercise exercise;
  const Description({Key? key, required this.exercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DescriptionViewState( );
}


class DescriptionViewState extends State<Description>{
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
                    widget.exercise.getCategoryString().toString(),
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
}