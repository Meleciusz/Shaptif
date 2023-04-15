import 'package:flutter/material.dart';

class Exercise extends StatelessWidget{
  const Exercise({Key? key}) : super(key: key);


  final String appBarText = 'Exercises list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: Text(appBarText)),
          automaticallyImplyLeading: false,
        ),

        body : Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: (){Navigator.pop(context);},
                child: Text('cos'),
              ),
            ],
          ),
        )


    );
  }
}