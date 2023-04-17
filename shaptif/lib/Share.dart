import 'package:flutter/material.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShareViewState();
}

class ShareViewState extends State<ShareView> {
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
