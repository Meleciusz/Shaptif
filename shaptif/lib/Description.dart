import 'package:flutter/material.dart';
import 'package:shaptif/db/DatabaseManager.dart';
import 'package:shaptif/db/Category.dart';
import 'package:shaptif/db/Exercise.dart';

class Description extends StatefulWidget {
  const Description({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DescriptionViewState();
}


class DescriptionViewState extends State<Description> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(

          )
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

                },
                backgroundColor: Colors.yellowAccent,
                shape: const CircleBorder(),
                child: const Icon(Icons.restore_from_trash_rounded),
              ),
            ]));

  }
}