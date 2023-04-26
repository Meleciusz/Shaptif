import 'package:flutter/material.dart';
import 'package:shaptif/db/Exercise.dart';
import 'package:shaptif/db/DatabaseManager.dart';
import 'package:shaptif/db/Category.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'NewExercise.dart';


class ExcerciseView extends StatefulWidget {
  const ExcerciseView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExcerciseViewState();
}

class ExcerciseViewState extends State<ExcerciseView> {
  @override
  void initState() {
    super.initState();

    refreshExcercises();
  }

  late List<Excercise> excercises;
  bool isLoading = false;

  Future refreshExcercises() async {
    setState(() => isLoading = true);

    excercises = await DatabaseManger.instance.selectAllExcercise();
    if (excercises.isEmpty) {
      await DatabaseManger.instance.initialData();
      excercises = await DatabaseManger.instance.selectAllExcercise();
    }
    for (var ex in excercises) {
      BodyPart c = await DatabaseManger.instance.selectBodyPart(ex.category);
      ex.categoryS = c.name;
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
    const int tabsCount = 3;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(74),
          child: AppBar(
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            backgroundColor: const Color.fromARGB(255, 183, 205, 144),
            // The elevation value of the app bar when scroll view has
            // scrolled underneath the app bar.
            scrolledUnderElevation: 4.0,
            shadowColor: Theme
                .of(context)
                .shadowColor,
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.back_hand, color: Colors.black),
                  text: '1',
                ),
                Tab(
                  icon: Icon(Icons.airline_seat_legroom_reduced_rounded,
                      color: Colors.black),
                  text: '2',
                ),
                Tab(
                  icon: Icon(Icons.person, color: Colors.black),
                  text: '3',
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  Color.fromARGB(255, 183, 205, 144)) //Color of indicator
          )
              : excercises.isEmpty
              ? const Text(
            'Brak ćwiczeń',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )
              : TabBarView(
            children: <Widget>[
              buildNotes(),
              buildNotes(),
              buildNotes(), //testing
            ],
          ),
        ),
        //backgroundColor: const Color.fromARGB(255, 31, 31, 33),
        floatingActionButton: FloatingActionButton(
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
        ),
      ),
    );
  }

  Widget buildNotes() => Scrollbar(
        child: ListView.builder(
          itemCount: excercises.length,
          itemBuilder: (context, index) {
            final excercise = excercises[index];
            return InkWell(
              onTap: () => _onExcerciseTap(excercise),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      );

  void _onExcerciseTap(Excercise excercise) {
    // Handle the excercise tap event here
    print('Tapped excercise: ${excercise.name}');
  }
}




