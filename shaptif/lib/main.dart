import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/History.dart';
import 'package:shaptif/Share.dart';
import 'package:shaptif/SharedPreferences.dart';
import 'package:shaptif/Styles.dart';
import 'package:shaptif/TrainingList.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DarkThemeProvider.dart';

void main() {
  runApp(MyApp());
}

//TODO: Odświeżanie danych po zmianie -> Należy zrobić to analogicznie do exercises (w main wszystkie zmienne przekazywane do ekranów i w main odświeżanie ich)
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  ShowEmbeddedProvider showEmbeddedProvider = ShowEmbeddedProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getShowEmbedded();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void getShowEmbedded() async {
    showEmbeddedProvider.showEmbedded =
        await showEmbeddedProvider.showEmbeddedPreference.getShowEmbedded();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_) => themeChangeProvider,
        ),
        ChangeNotifierProvider<ShowEmbeddedProvider>(
          create: (_) => showEmbeddedProvider,
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            //debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: SplashScreen(),

            // routes: <String, WidgetBuilder>{
            //     AGENDA
            // },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Align(
        child: Row(children: const [
          Text(
            'S',
            style: TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 120),
          ),
          Text(
            'haptif',
            style: TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 60),
          ),
        ]),
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
  late List<Exercise> exercises;

  bool isLoading = false;
  int currentBottomNavBarIndex = 0;
  final String appBarText = 'Shaptif';

  List<Widget>? screens;

  void loadScreens() {
    isLoading = false;
    screens = [
      ExcerciseView(
        onExerciseChanged: (value) async {
          await refreshExercises();
          setState(() {
          });
        },
        exercises: exercises,
      ),
      const TrainingListView(),
      const HistoryView(),
      const SettingsView(),
      const ShareView(),
    ];
  }

  Future refreshExercises() async {
    exercises = await DatabaseManger.instance.selectAllExercises();
  }

  void CheckDatabase() {
    setState(() => isLoading = true);

    DatabaseManger.instance.selectAllExercises().then((exercises) {
      if (exercises.isEmpty) {
        SharedPreferences.getInstance().then((prefs) {
          if (prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true) {
            DatabaseManger.instance.initialData().then((_) {
              DatabaseManger.instance.selectAllExercises().then((exercises) {
                setState(() {
                  this.exercises = exercises;
                  loadScreens();
                });
              });
            });
          } else {
            setState(() {
              this.exercises = exercises;
              loadScreens();
            });
          }
        });
      } else {
        setState(() {
          this.exercises = exercises;
          loadScreens();
        });
      }
    });
  }

  Widget buildProgressIndicator(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: Colors.green,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    CheckDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (screens == null) {
      return buildProgressIndicator(context);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/ksiazka.png",
                fit: BoxFit.contain,
                height: 110,
              ),
            ],
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
      ),
      body: IndexedStack(
        index: currentBottomNavBarIndex,
        children: screens!,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentBottomNavBarIndex,
          onTap: (index) => setState(() => currentBottomNavBarIndex = index),
          iconSize: 30,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedItemColor: const Color.fromARGB(255, 172, 111, 199),
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
