import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shaptif/NewExercise.dart';
import 'package:shaptif/QRReader.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShareViewState();
}

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
              Fluttertoast.showToast(
                msg: value ?? "Nie udało się odczytać QR"
              );
            })
            ;
          },
          child: Text('Skanuj QR'),
        ),
      ),
    );
  }
}
