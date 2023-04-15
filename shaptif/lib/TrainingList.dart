import 'package:flutter/material.dart';
import 'package:shaptif/CustomAppBar.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  final String appBarText = 'Your training list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: Text(appBarText)),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cos'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BasicBottomAppBar());
  }
}
