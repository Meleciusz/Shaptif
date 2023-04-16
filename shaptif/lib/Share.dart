import 'package:flutter/material.dart';
import 'package:shaptif/CustomAppBar.dart';

class Share extends StatelessWidget {
  const Share({Key? key}) : super(key: key);

  final String appBarText = 'Shaptif';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 31, 31, 33),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/ksiazka.png"),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              title: Text(
                appBarText,
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))
              ),
              automaticallyImplyLeading: false,
            ),),
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
          ),)
    );
  }
}
