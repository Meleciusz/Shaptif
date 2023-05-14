import 'package:flutter/material.dart';
//import 'DarkThemeProvider.dart';
import 'package:shaptif/TrainingBuilder.dart';


class NewTrainingView extends StatefulWidget {
  const NewTrainingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewTrainingViewState();
}

class NewTrainingViewState extends State<NewTrainingView> {
  //DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState(){
    super.initState();
    //getCurrentAppTheme();
  }

  // void getCurrentAppTheme() async {
  //   themeChangeProvider.darkTheme =
  //   await themeChangeProvider.darkThemePreference.getTheme();
  // }
  Set<String> exercises = {};
  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery. of(context). size. height;
    return Scaffold(
      appBar: AppBar(),
        body: Column(
          children: [
            Flexible(
                  child:
                    ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index){
                          return Ink(
                            //color: Colors.white,
                              child: ListTile(
                                title: Text('${exercises.elementAt(index)}', textAlign: TextAlign.center,),
                                //textColor: Colors.black,
                              )
                          );
                        })
                ),
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
                          MaterialPageRoute(builder: (context) => const TrainingBuilderView())
                      ).then((value){
                        if(value != null){
                          setState(() {
                            exercises.add(value);
                          });
                        }
                      });
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
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),

  );

  }
}
