import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
