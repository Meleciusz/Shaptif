import 'package:flutter/material.dart';
import 'package:shaptif/CustomAppBar.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/History.dart';
import 'package:shaptif/NewTraining.dart';
import 'package:shaptif/Share.dart';
import 'package:shaptif/TrainingList.dart';
import 'package:shaptif/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
        // colorScheme.background : Color.fromARGB(),
        backgroundColor: Color.fromARGB(255, 50, 50, 52),
      ),
      home: const MyHomePage(title: 'Shaptif'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentBottomNavBarIndex = 0;
  final screens = [Exercise(), TrainingList(), History(), Settings(), Share()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentBottomNavBarIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentBottomNavBarIndex,
          onTap: (index) => setState(() => currentBottomNavBarIndex = index),
          iconSize: 30,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedItemColor: Color.fromARGB(255, 183, 205, 144),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                tooltip: 'Excercise list',
                icon: Icon(Icons.menu_rounded),
                label: 'Exercises',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                tooltip: 'Training list',
                icon: Icon(Icons.sports_gymnastics_rounded),
                label: 'Trainings',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                tooltip: 'History',
                icon: Icon(Icons.history_rounded),
                label: 'History',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                tooltip: 'Settings',
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                tooltip: 'Share',
                icon: Icon(Icons.share_rounded),
                label: 'Share',
                backgroundColor: Colors.black)
          ]

          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
