import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DarkThemeProvider.dart';
import 'SharedPreferences.dart';
import 'TrainingBuilder.dart';
import 'db/database_manager.dart';
import 'db/exercise.dart';

class NewTrainingView extends StatefulWidget {
  const NewTrainingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<NewTrainingView> {
  @override

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery. of(context). size. height;
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: Size(56, 56),
              child: ClipOval(
                child: Material(
                  color: Colors.green,
                  child: InkWell(
                    splashColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TrainingBuilder()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add), // <-- Icon
                        Text("Add"),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

  );

  }
}
