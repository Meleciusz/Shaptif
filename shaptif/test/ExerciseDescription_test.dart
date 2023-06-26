import 'package:flutter/material.dart';
import 'package:shaptif/ExerciseDescription.dart' as ed;
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shaptif/db/exercise.dart';

void main() {

  final exercises = <Exercise>[];
  final exercise = Exercise(name: "my_exercise", description: "my_description", bodyPart: 1, isEmbedded: true);
  exercises.add(exercise);

  testWidgets('Description test', (tester) async {
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
            child : ed.Description(exercise: exercise, exercises: exercises),
        ),
      ),
    );

  });
}