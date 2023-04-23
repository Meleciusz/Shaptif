import 'package:flutter/material.dart';
import 'package:shaptif/db/Exercise.dart';
import 'package:shaptif/db/DatabaseManager.dart';

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

    DatabaseManger.instance.deleteAllExcercises();

    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+")); DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Podciąganie", description: "pod chwytem tylko"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Szruksy", description: "czuje ze zyje"));
    DatabaseManger.instance.insertExcercise(
        const Excercise(name: "Modlitewnik", description: "+"));

    refreshNotes();
  }

  late List<Excercise> excercises;
  bool isLoading = false;

  Future refreshNotes() async {
    setState(() => isLoading = true);
    excercises = await DatabaseManger.instance.selectAllExcercises();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ćwiczenia',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [Icon(Icons.search), SizedBox(width: 12)],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : excercises.isEmpty
                ? const Text(
                    'Brak ćwiczeń',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      floatingActionButton: FloatingActionButton(
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
