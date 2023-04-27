import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/History.dart';
import 'package:shaptif/Share.dart';
import 'package:shaptif/Styles.dart';
import 'package:shaptif/TrainingList.dart';
import 'package:shaptif/settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DarkThemeProvider.dart';
import 'SharedPreferences.dart';

void main() {
  runApp(MyApp());
  //SharedPreferences.setMockInitialValues({});
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
      await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
      return themeChangeProvider;
    },
    child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget? child){
          return MaterialApp(
              //debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: SplashScreen(),

            // routes: <String, WidgetBuilder>{
            //     AGENDA
            //},

            );
          },

      ),
    );
  }
}


class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
        splash: Align(
          child: Row(
            children: const [
              Text(
                'S',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 120),
              ),
              Text(
                'H',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),Text(
                'A',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),Text(
                'P',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),Text(
                'T',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),Text(
                'I',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),Text(
                'F',
                style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ]
          ),
        ),

        nextScreen: const MyHomePage(title: 'Shaptif'),
        splashTransition: SplashTransition.slideTransition,
      backgroundColor: Colors.black,
      splashIconSize: 250,
      pageTransitionType: PageTransitionType.topToBottom,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  int currentBottomNavBarIndex = 0;
  final String appBarText = 'Shaptif';
  final screens = [
    const ExcerciseView(),
    const TrainingListView(),
    const HistoryView(),
    const SettingsView(),
    const ShareView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/ksiazka.png"),
                  fit: BoxFit.fill,
                )),
          ),
          title: Text(
            appBarText,
            style: const TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          backgroundColor: const Color.fromARGB(255, 183, 205, 144),
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         bottomRight: Radius.circular(20),
          //         bottomLeft: Radius.circular(20))),
          automaticallyImplyLeading: false,
        ),
      ),
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
          selectedItemColor: const Color.fromARGB(255, 183, 205, 144),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                tooltip: 'Exercise list',
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
