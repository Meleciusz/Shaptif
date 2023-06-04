import 'package:flutter/material.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DarkThemeProvider.dart';
import 'ExerciseDescription.dart';
import 'NewExercise.dart';
import 'SharedPreferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExcerciseView extends StatefulWidget {
  const ExcerciseView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExcerciseViewState();
}
//TODO: SCROLLBAR FIX
class ExcerciseViewState extends State<ExcerciseView> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  int? exercisesSize;

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    refreshExercises();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  late List<Exercise> exercises;
  bool isLoading = false;

  Future refreshExercises() async {
    setState(() => isLoading = true);

    exercises = await DatabaseManger.instance.selectAllExercises();
    if (exercises.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true) {
        await DatabaseManger.instance.initialData();
        exercises = await DatabaseManger.instance.selectAllExercises();
      }
    }
    exercisesSize = exercises.length;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
    List<Exercise> exercisesInCategory = [];

    for (Exercise exercise in exercises) {
      if (exercise.bodyPartString! == category)
        exercisesInCategory.add(exercise);
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: exercisesInCategory.length,
        itemBuilder: (context, index) {
          var exercise = exercisesInCategory[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Description(exercise: exercise, exercises: exercises,)),
              ).then((value) {
                setState(() {
                  exercises;
                });
                if(exercisesSize!=exercises.length)
                {
                  exercisesSize = exercises.length;
                  Fluttertoast.showToast(
                    msg: "Usunięto ćwiczenie",
                  );
                }
              });
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Center(
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        exercise.name,
                        style: const TextStyle(
                            fontFamily: 'Audiowide',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
     return PreferredSize(
      preferredSize: const Size.fromHeight(74),
      child: AppBar(
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        //backgroundColor: Colors.black,
        scrolledUnderElevation: 4.0,
        shadowColor: Theme.of(context).shadowColor,
        bottom: buildBottomTabBar(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "AddExerciseButton",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewExercise(
                    exercises: exercises,
                  )),
        ).then((value) {
          setState(() {
            exercises;
          });
          if(exercisesSize!=exercises.length)
            {
              exercisesSize = exercises.length;
              Fluttertoast.showToast(
              msg: "Dodano " + exercises.last.name.toLowerCase(),
            );
            }
        });

        //isLoading ? buildProgressIndicator(context) : refreshExercises();
      },
      backgroundColor: const Color.fromARGB(255, 41, 201, 175),
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
      icon: Icon(icon),
      text: text,
    );
  }

  Widget buildProgressIndicator(BuildContext context) {
    return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
      Colors.black,
    ) //Color of indicator
        );
  }

  Widget buildEmptyView(BuildContext context) {
    return const Text(
      'Brak ćwiczeń',
      style: TextStyle(color: Colors.redAccent, fontSize: 24),
    );
  }
}
