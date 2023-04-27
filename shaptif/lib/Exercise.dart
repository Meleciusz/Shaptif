import 'package:flutter/material.dart';
import 'package:shaptif/db/Exercise.dart';
import 'package:shaptif/db/DatabaseManager.dart';
import 'package:shaptif/db/Category.dart';

import 'DarkThemeProvider.dart';
import 'Description.dart';
import 'NewExercise.dart';


class ExcerciseView extends StatefulWidget {
  const ExcerciseView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExcerciseViewState();
}

class ExcerciseViewState extends State<ExcerciseView> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    refreshExcercises();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  late List<Excercise> exercises;
  bool isLoading = false;

  Future refreshExcercises() async {
    setState(() => isLoading = true);

    exercises = await DatabaseManger.instance.selectAllExcercise();
    if (exercises.isEmpty) {
      await DatabaseManger.instance.initialData();
      exercises = await DatabaseManger.instance.selectAllExcercise();
    }
    for (var ex in exercises) {
      BodyPart bodypart = await DatabaseManger.instance.selectBodyPart(ex.category);
      ex.categoryS = bodypart.name;
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    const int tabsCount = 6;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Center(
          child: isLoading
              ? buildProgressIndicator(context)
              : exercises.isEmpty
              ? buildEmptyView(context)
              : buildTabBarContext(),
        ),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  Scrollbar buildTilesFromCategory(String category) {
    List<Excercise> exercisesInCategory = [];
    for (var exercise in exercises)
      {
        if(exercise.categoryS==category)
          exercisesInCategory.add(exercise);
      }

    return Scrollbar(
      child: ListView.builder(
        itemCount: exercisesInCategory.length,
        itemBuilder: (context, index) {
          final excercise = exercisesInCategory[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Description()),
              );
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Center(
                child: Text(
                  excercise.name,
                  style: const TextStyle(
                      fontFamily: 'Audiowide',
                      //color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  PreferredSize buildAppBar(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PreferredSize(
      preferredSize: const Size.fromHeight(74),
      child: AppBar(
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        backgroundColor: const Color.fromARGB(255, 183, 205, 144),
        scrolledUnderElevation: 4.0,
        shadowColor: Theme.of(context).shadowColor,
        bottom: buildBottomTabBar(),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
   return FloatingActionButton(
      heroTag: "AddExerciseButton",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewExercise()),
        );
      },
      backgroundColor: const Color.fromARGB(255, 58, 183, 89),
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  buildTabBarContext() {
    return TabBarView(
      children: <Widget>[
        buildTilesFromCategory("rece"),
        buildTilesFromCategory("nogi"),
        buildTilesFromCategory("klatka piersiowa"),
        buildTilesFromCategory("plecy"),
        buildTilesFromCategory("brzuch"),
        buildTilesFromCategory("barki"),
      ],
    );
  }

  TabBar buildBottomTabBar() {
    return TabBar(
      tabs: <Widget>[
        buildTab(Icons.back_hand, 'Ręce'),
        buildTab(Icons.airline_seat_legroom_reduced_rounded, 'Nogi'),
        buildTab(Icons.person, 'Klata'),
        buildTab(Icons.person, 'Plecy'),
        buildTab(Icons.person, 'Brzuch'),
        buildTab(Icons.person, 'Barki'),
      ],
    );
  }

  Tab buildTab(IconData icon, String text) {
    return Tab(
      icon: Icon(icon, color: Colors.black),
      text: text,
    );
  }

  Widget buildProgressIndicator(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Color.fromARGB(255, 183, 205, 144)), //Color of indicator
    );
  }

  Widget buildEmptyView(BuildContext context) {
    return const Text(
      'Brak ćwiczeń',
      style: TextStyle(color: Colors.white, fontSize: 24),
    );
  }

}




