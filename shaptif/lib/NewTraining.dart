import 'package:flutter/material.dart';

class NewTraining extends StatelessWidget {
  const NewTraining({Key? key}) : super(key: key);

  final String appBarText = 'Shaptif';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: Center(
        child: Column(
            // children: <Widget>[
            //   ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: const Text('cos'),
            //   ),
            // ],
            ),
      ),
    ));
  }
}
