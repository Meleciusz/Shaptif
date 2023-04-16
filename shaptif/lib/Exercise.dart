import 'package:flutter/material.dart';

class Exercise extends StatelessWidget {
  const Exercise({Key? key}) : super(key: key);

  final String appBarText = 'Shaptif';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: Center(
        child: Column(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Smack me!"),
              action: SnackBarAction(
                  label: "Fuck",
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  })));
        },
        backgroundColor: const Color.fromARGB(255, 58, 183, 89),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    ));
  }
}
