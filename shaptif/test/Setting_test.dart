import 'package:flutter/material.dart';
import 'package:shaptif/settings.dart';
import 'package:shaptif/DarkThemeProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main(){
  testWidgets('Switches test', (tester) async {
    // Build our app and trigger a frame.
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
          child: SettingsView(),
        ),
      ),
    );

    final switchListTiles = find.byWidgetPredicate((widget) {
      return widget is SwitchListTile;
    });
    expect(switchListTiles, findsNWidgets(2));

    final lightswitch = find.widgetWithText(SwitchListTile, 'Lights');
    expect(lightswitch, findsOneWidget);

    final appFinder = find.byType(MaterialApp);
    final appElement = appFinder.evaluate().first.widget as MaterialApp;
    final app = appElement.theme;
    final labelTheme = find.text("Lights");
    final widget = tester.widget<Text>(labelTheme);

    if(app != null) {
      expect(app.scaffoldBackgroundColor, Colors.white);
      expect(widget.style?.color, Colors.black);
      await tester.tap(lightswitch);
      expect(app.scaffoldBackgroundColor, Colors.black);
      expect(widget.style?.color, Colors.white);
    }
    });

  testWidgets('Labels test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
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
          child: SettingsView(),
        ),
      ),
    );

    final labelTheme = find.text("Lights");
    expect(labelTheme, findsOneWidget);
    final labelEmbedded = find.text("Show embedded exercises and trainings");
    expect(labelEmbedded, findsOneWidget);
  });
  }