import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRReader extends StatefulWidget {
  const QRReader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRReaderState();
}

class QRReaderState extends State<QRReader> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  String? qrText;

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  bool goesBack = false;

  void goBack()
  {
    if(!goesBack)
    {
      goesBack = true;
      Navigator.pop(context, qrText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(qrText ?? ""),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onRequestPermissionsResult(
      int requestCode, List<String> permissions, List<int> grantResults) async {
    switch (requestCode) {
      case 100:
        return grantResults[0] == PermissionStatus.granted.index;
      default:
        return true;
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      qrController = controller;
    });

    final status = await Permission.camera.request();
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Uprawnienia kamery'),
          content: Text('Proszę przyznać uprawnienia do używania kamery'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, "Brak uprawnień");
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (status.isGranted) {
      qrController.scannedDataStream.listen((scanData) {

          //setState(() {
            qrText = scanData.code;
            goBack();
          //});

      });

    } else {
      //setState(() {
        qrText = 'Brak wymaganych uprawnień';
        goBack();
      //});
    }
  }

  void leaveScreen()
  {
    Navigator.pop(context);
  }

  bool isValidQR()
  {
    return true;
  }



}
