import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shaptif/NewExercise.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShareViewState();
}

class ShareViewState extends State<ShareView> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  String qrText = '';

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
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
              child: Text(qrText),
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
          title: Text('Camera permission'),
          content: Text('Please grant permission to use the camera.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (status.isGranted) {
      qrController.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = scanData.code!;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewExercise(
                jsonString: scanData.code,
              )),
        );
      });
    } else {
      setState(() {
        qrText = 'Failed to get camera permission';
      });
    }
  }
}
