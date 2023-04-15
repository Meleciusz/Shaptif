import 'package:flutter/material.dart';
import 'package:shaptif/CustomAppBar.dart';

class Share extends StatelessWidget {
  const Share({Key? key}) : super(key: key);

  final String appBarText = 'Share it with your friends!';
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
      bottomNavigationBar: BasicBottomAppBar(),
    );
  }
}
