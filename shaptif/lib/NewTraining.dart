import 'package:flutter/material.dart';

class NewTrainingView extends StatefulWidget {
  const NewTrainingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<NewTrainingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: Center(
        child: Row(
            children: <Widget>[

            //   ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: const Text('cos'),
            //   ),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        shape: const CircleBorder(),
        child: const Icon(Icons.keyboard_backspace),
      ),
    );
  }
}
