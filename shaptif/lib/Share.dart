import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shaptif/NewExercise.dart';
import 'package:shaptif/QRReader.dart';
import 'package:shaptif/db/exercise.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShareViewState();
}
//TODO:
//-when exercise is added, user should be moved to corresponding Exercise screen
//-when exercise is added, Exercise screen should refresh exercise list from DB
class ShareViewState extends State<ShareView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRReader()),
            ).then((value) {

              if(value!=null)
                {
                  Exercise? jsonExercise = Exercise.fromQR(value);
                  if(jsonExercise != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewExercise(
                              jsonExercise: jsonExercise,
                            )),
                      ).then((value) {
                        Fluttertoast.showToast(
                          msg: value != null ? "Dodano "+value : "Nic nie dodano",
                        );
                      });
                    }
                  else
                    {
                      Fluttertoast.showToast(
                        msg: "Nie poprawny kod QR",
                      );
                    }
                }
              else
                {
                  Fluttertoast.showToast(
                    msg: "Nie udało się odczytać kodu QR",
                  );
                }
            });


          },
          child: Text('Skanuj QR'),
        ),
      ),
    );
  }
}
