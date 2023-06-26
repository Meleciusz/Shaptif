import 'package:flutter/material.dart';
import 'package:shaptif/Exercise.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/NewExercise.dart';

void main(){
  testWidgets('Icons test', (tester) async {
    final exercises = <Exercise>[]; // Przykładowa lista ćwiczeń
    bool exerciseChangedValue = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<DarkThemeProvider>(
              create: (_) => DarkThemeProvider(),
            ),
            ChangeNotifierProvider<ShowEmbeddedProvider>(
              create: (_) => ShowEmbeddedProvider(),
            ),
          ],
          child: ExcerciseView(
            onExerciseChanged: (value) {
              exerciseChangedValue = value; // Zapisz wartość zmiany ćwiczenia
            },
            exercises: exercises, // Przekazanie listy ćwiczeń
          ),
        ),
      ),
    );

    final iconsNumber = find.byType(Icon);
    expect(iconsNumber, findsNWidgets(7));

    final iconHand = find.widgetWithIcon(Tab, Icons.back_hand);
    expect(iconHand, findsOneWidget);
    final iconLeg = find.widgetWithIcon(Tab, Icons.airline_seat_legroom_reduced_rounded);
    expect(iconLeg, findsOneWidget);
    //TODO change to real icons
    // final iconChest = find.widgetWithIcon(Tab, Icons.person);
    // expect(iconChest, findsOneWidget);
    // final iconBack = find.widgetWithIcon(Tab, Icons.person);
    // expect(iconBack, findsOneWidget);
    // final iconAbs = find.widgetWithIcon(Tab, Icons.person);
    // expect(iconAbs, findsOneWidget);
    // final iconArm = find.widgetWithIcon(Tab, Icons.person);
    // expect(iconArm, findsOneWidget);
    final iconAdd = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(iconAdd, findsOneWidget);



  });
  testWidgets('Exercise test', (tester) async {
    final exercises = <Exercise>[]; // Przykładowa lista ćwiczeń
    bool exerciseChangedValue = false;
    final Exercise? _jsonExercise;

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<DarkThemeProvider>(
              create: (_) => DarkThemeProvider(),
            ),
            ChangeNotifierProvider<ShowEmbeddedProvider>(
              create: (_) => ShowEmbeddedProvider(),
            ),
          ],
          child: ExcerciseView(
            onExerciseChanged: (value) {
              exerciseChangedValue = value; // Zapisz wartość zmiany ćwiczenia
            },
            exercises: exercises, // Przekazanie listy ćwiczeń
          ),
        ),
        routes: {
          '/second': (_) => NewExercise(exercises: [],jsonExercise: null,),
        },
      ),
    );

    final addButton = find.byWidgetPredicate((widget) {
      return widget is FloatingActionButton;
    });
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
//TODO add checking the new screen loading
    //await tester.pumpAndSettle();
    //final newExerciseScreen = find.byType(NewExercise);
    //expect(newExerciseScreen, findsOneWidget);

  });
}