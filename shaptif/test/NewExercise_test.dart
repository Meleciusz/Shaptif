import 'package:flutter/material.dart';
import 'package:shaptif/NewExercise.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main(){
  testWidgets('NewExercise test', (tester) async {
    final exercises = <Exercise>[]; // Przykładowa lista ćwiczeń

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
          child: NewExercise(
            exercises: exercises,
            jsonExercise: null, // Przykładowa wartość jsonExercise
          ),
        ),
      ),
    );


  });


}