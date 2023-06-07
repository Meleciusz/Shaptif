import 'package:path/path.dart';
import 'package:shaptif/SharedPreferences.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/db/body_part.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/setup.dart';
import 'dart:io';

import 'history.dart';

class DatabaseManger {
  static final DatabaseManger instance = DatabaseManger._init();

  static Database? _database;

  DatabaseManger._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Shaptif.db');
    return _database!;
  }

  void dropDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Shaptif.db');
    final file = File(path);
    if (await file.exists()) {
      file.deleteSync();
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final result = await openDatabase(path, version: 1, onCreate: _createDB);

    return result;
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const booleanType = 'BOOLEAN NOT NULL';

    await db.execute('PRAGMA foreign_keys = ON;');

    await db.execute('''
    CREATE TABLE ${BodyPartDatabaseSetup.tableName} ( 
    ${BodyPartDatabaseSetup.id} $idType, 
    ${BodyPartDatabaseSetup.name} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${ExerciseDatabaseSetup.tableName} ( 
    ${ExerciseDatabaseSetup.id} $idType, 
    ${ExerciseDatabaseSetup.name} $textType,
    ${ExerciseDatabaseSetup.description} $textType,
    ${ExerciseDatabaseSetup.bodyPart} $intType,
    ${ExerciseDatabaseSetup.imageHash} $intType,
    ${ExerciseDatabaseSetup.isEmbedded} $booleanType,
    FOREIGN KEY(${ExerciseDatabaseSetup.bodyPart}) REFERENCES ${BodyPartDatabaseSetup.tableName} (${BodyPartDatabaseSetup.id})
    )
    ''');

    await db.execute('''
    CREATE TABLE ${TrainingDatabaseSetup.tableName} ( 
    ${TrainingDatabaseSetup.id} $idType, 
    ${TrainingDatabaseSetup.name} $textType,
    ${TrainingDatabaseSetup.description} $textType,
    ${TrainingDatabaseSetup.isEmbedded} $booleanType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${ExerciseSetDatabaseSetup.tableName} ( 
    ${ExerciseSetDatabaseSetup.id} $idType, 
    ${ExerciseSetDatabaseSetup.trainingID} $intType,
    ${ExerciseSetDatabaseSetup.exerciseID} $intType,
    ${ExerciseSetDatabaseSetup.repetitions} $intType,
    ${ExerciseSetDatabaseSetup.weight} $doubleType,
    FOREIGN KEY(${ExerciseSetDatabaseSetup.trainingID}) REFERENCES ${TrainingDatabaseSetup.tableName} (${TrainingDatabaseSetup.id}),
    FOREIGN KEY(${ExerciseSetDatabaseSetup.exerciseID}) REFERENCES ${ExerciseDatabaseSetup.tableName} (${ExerciseDatabaseSetup.id})
    )
    ''');

    await db.execute('''
    CREATE TABLE ${FinishedTrainingDatabaseSetup.tableName} ( 
    ${FinishedTrainingDatabaseSetup.id} $idType, 
    ${FinishedTrainingDatabaseSetup.name} $textType,
    ${FinishedTrainingDatabaseSetup.description} $textType,
    ${FinishedTrainingDatabaseSetup.finishedDateTime} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${HistoryDatabaseSetup.tableName} ( 
    ${HistoryDatabaseSetup.id} $idType, 
    ${HistoryDatabaseSetup.trainingID} $intType,
    ${HistoryDatabaseSetup.exerciseID} $intType,
    ${HistoryDatabaseSetup.repetitions} $intType,
    ${HistoryDatabaseSetup.weight} $doubleType,
    FOREIGN KEY(${HistoryDatabaseSetup.trainingID}) REFERENCES ${TrainingDatabaseSetup.tableName} (${TrainingDatabaseSetup.id}),
    FOREIGN KEY(${HistoryDatabaseSetup.exerciseID}) REFERENCES ${ExerciseDatabaseSetup.tableName} (${ExerciseDatabaseSetup.id})
    )
    ''');
  }

  Future<TableObject> insert(TableObject object) async {
    final db = await instance.database;

    final id = await db.insert(object.getTableName(), object.toJson());
    return object.copy(returnedId: id);
  }

  Future insertList(List<TableObject> objects) async{
    Batch batch = (await instance.database).batch();
    final tableName = objects.first.getTableName();

    for(var object in objects)
      batch.insert(tableName, object.toJson());

    await batch.commit(noResult: true);
  }

  Future<Exercise> selectExercise(int id) async {
    final db = await instance.database;

    final maps = await db.rawQuery(
        "${ExerciseDatabaseSetup.selectString} WHERE ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.id} == $id");

    return maps.isNotEmpty
        ? Exercise.fromJson(maps.first)
        : throw Exception('ID $id not found');
  }

  Future<BodyPart> selectBodyPart(int id) async {
    final row = await select(id, BodyPartDatabaseSetup.tableName,
        BodyPartDatabaseSetup.id, BodyPartDatabaseSetup.valuesToRead);

    return BodyPart.fromJson(row);
  }

  Future<Training> selectTraining(int id) async {
    final row = await select(id, TrainingDatabaseSetup.tableName,
        TrainingDatabaseSetup.id, TrainingDatabaseSetup.valuesToRead);

    return Training.fromJson(row);
  }

  // Future<MySet> selectSet(int id, {bool finished = false}) async {
  //   final db = await instance.database;
  //
  //   final rows = !finished ?
  //   await db.rawQuery("${SetDatabaseSetup.selectString} WHERE ${SetDatabaseSetup.tableName}.${SetDatabaseSetup.id} == $id")
  //   : await db.rawQuery("${HistoryDatabaseSetup.selectString} WHERE ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.id} == $id")
  //   ;
  //
  //   return MySet.fromJson(rows.first);
  // }

  Future<List<ExerciseSet>> selectSetsByTraining(int id) async {
    final db = await instance.database;

    final rows = await db.rawQuery(
        "${ExerciseSetDatabaseSetup.selectString} WHERE ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.trainingID} == $id");

    return rows.map((json) => ExerciseSet.fromJson(json)).toList();
  }

  Future<List<ExerciseSet>> selectSetsByExerciseInTraining(int trainingId, int exerciseId) async {
    final db = await instance.database;

    final rows = await db.rawQuery(
        "${ExerciseSetDatabaseSetup.selectString} WHERE ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.trainingID} == $trainingId"+" AND ${ExerciseDatabaseSetup.id} == $exerciseId ORDER BY ${ExerciseSetDatabaseSetup.id} DESC");

    return rows.map((json) => ExerciseSet.fromJson(json)).toList();
  }


  Future<List<History>> selectHistoryByTraining(int id) async {
    final db = await instance.database;

    final rows = await db.rawQuery(
        "${HistoryDatabaseSetup.selectString} WHERE ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.trainingID} == $id");

    return rows.map((json) => History.fromJson(json)).toList();
  }

  Future<Map<String, Object?>> select(int id, String tableName, String idName,
      List<String> valuesToRead) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      columns: valuesToRead,
      where: '$idName = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty ? maps.first : throw Exception('ID $id not found');
  }

  Future<List<Exercise>> selectAllExercises() async {
    final db = await instance.database;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showEmbedded =
        prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true;

    return (await db.rawQuery(ExerciseDatabaseSetup.selectString +
            (showEmbedded
                ? ""
                : "WHERE ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.isEmbedded} == false")))
        .map((json) => Exercise.fromJson(json))
        .toList();
  }

  Future<List<BodyPart>> selectAllBodyParts() async {
    final db = await instance.database;
    return (await db.query(BodyPartDatabaseSetup.tableName,
            orderBy: "${BodyPartDatabaseSetup.name} ASC"))
        .map((json) => BodyPart.fromJson(json))
        .toList();
  }

  Future<List<Training>> selectAllTrainings() async {
    final db = await instance.database;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showEmbedded =
        prefs.getBool(ShowEmbeddedPreference.EMBEDDED_STATUS) ?? true;

    return showEmbedded
        ? (await db.query(TrainingDatabaseSetup.tableName,
                orderBy: "${TrainingDatabaseSetup.name} ASC"))
            .map((json) => Training.fromJson(json))
            .toList()
        : (await db.query(TrainingDatabaseSetup.tableName,
                where: '${TrainingDatabaseSetup.isEmbedded} = ?',
                whereArgs: [false],
                orderBy: "${TrainingDatabaseSetup.name} ASC"))
            .map((json) => Training.fromJson(json))
            .toList();
  }

  Future<List<FinishedTraining>> selectAllFinishedTrainings() async {
    final db = await instance.database;
    return (await db.query(FinishedTrainingDatabaseSetup.tableName,
            orderBy: "${FinishedTrainingDatabaseSetup.finishedDateTime} DESC"))
        .map((json) => FinishedTraining.fromJson(json))
        .toList();
  }

  Future<int> update(TableObject ex) async {
    final db = await instance.database;

    return db.update(
      ex.getTableName(),
      ex.toJson(),
      where: '${ex.getIdName()} = ?',
      whereArgs: [ex.id],
    );
  }

  Future<int> delete(TableObject object) async {
    final db = await instance.database;

    return await db.delete(
      object.getTableName(),
      where: '${object.getIdName()} = ?',
      whereArgs: [object.id],
    );
  }

  // Future<int> deleteExercise(int id) async {
  //   final db = await instance.database;
  //
  //   return await db.delete(
  //     ExerciseDatabaseSetup.tableName,
  //     where: '${ExerciseDatabaseSetup.id} = ?',
  //     whereArgs: [id],
  //   );
  // }
  //
  // Future<int> deleteAllExercises() async {
  //   final db = await instance.database;
  //
  //   return await db.delete(ExerciseDatabaseSetup.tableName);
  // }

  Future executeRawQuery(String query) async {
    final db = await instance.database;

    await db.execute(query);
  }

  Future<bool> isExerciseInDB(int id) async {
    final db = await instance.database;

    var result = await db.rawQuery(
        'SELECT COUNT(${ExerciseSetDatabaseSetup.exerciseID}) FROM ${ExerciseSetDatabaseSetup.tableName} WHERE ${ExerciseSetDatabaseSetup.exerciseID} == $id');
    var count = Sqflite.firstIntValue(result);
    if (count != 0) {
      return false;
    } else {
      result = await db.rawQuery(
          'SELECT COUNT(${HistoryDatabaseSetup.id}) FROM ${HistoryDatabaseSetup.tableName} WHERE ${HistoryDatabaseSetup.exerciseID} == $id');
      count = Sqflite.firstIntValue(result);
      return count != 0 ? false : true;
    }
  }

  Future initialData() async {
    final db = instance;
    await db.insert(BodyPart(name: "plecy"));
    await db.insert(BodyPart(name: "klatka piersiowa"));
    await db.insert(BodyPart(name: "barki"));
    await db.insert(BodyPart(name: "nogi"));
    await db.insert(BodyPart(name: "rece"));
    await db.insert(BodyPart(name: "brzuch"));

    await db.insert(Exercise(
        name: "Szrugsy",
        description: "Stań prosto z wyprostowanym ramionami wzdłuż tułowia, lekko ugiętymi w łokciu. Utrzymując tą pozycję unieś barki w górę. Zatrzymaj na chwilę barki w górze, a następnie powoli je opuść.\nStaraj się nie kołysać tułowiem i trzymaj głowę w jednej linii z plecami.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 16384));
    await db.insert(Exercise(
        name: "Podciąganie",
        description: "Złap za drążek podchwytem lub nachwytem, szerzej niż szerokość barków, ze wzrokiem skierowanym przed siebie. Ściągnij łopatki i podciągnij się do góry, zatrzymując się na chwilę w najwyższym punkcie, a następnie powoli opuść ciało co wyprostu ramion.\nStaraj się nie zarzucać ciała w górę oraz wykonywać ruch z mięśni grzbietu, a nie ramion.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 16514));
    await db.insert(Exercise(
        name: "Zwis aktywny",
        description: "Złap za drążek nachwytem, szerzej niż na szerokość barków. Ramiona powinny być wyprostowane, a wzrok skierowany przed siebie. Ściągnij łopatki w tył i w dół (nie uginając ramion).  Utrzymaj się w tej pozycji przez określony czas, a następnie kontrolowanych ruchem wróć do pozycji początkowej.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 16512));
    await db.insert(Exercise(
        name: "Ściąganie drążka",
        description: "Chwyć drążek na szerokość barków lub trochę szerzej. Lekko odchyl się do tyłu, ściągnij łopatki i opuść barki w dół. Ściągnij drążek w dół, na wysokość klatki piersiowej. Zatrzymaj się na chwilę, a następnie powoli opuść ciężar.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 16514));
    await db.insert(Exercise(
        name: "Wiosłowanie hantlą",
        description: "Stań w pozycji wykrocznej, rękę po stronie nogi wykrocznej oprzyj na ławeczce lub w innym miejscu. Plecy powinny być proste, a ramię ręki z hantlą skierowane w dół. Przyciągnij hantlę pionowo w górę, w kierunku biodra, równocześnie ściągając łopatkę. Zatrzymaj się na chwile, a następnie wolno opuść hantlę w dół.\nStaraj się utrzymać proste plecy w trakcie ćwiczenia, a ruch wykonywać napinając mięśnie pleców, a nie ramion. Nie szarp ciężaru, a ruch wykonuj powoli.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 16576));
    await db.insert(Exercise(
        name: "Wiosłowanie sztangą",
        description: "Ustaw stopy na szerokość bioder, złap sztangę (podchwytem lub nachwytem) nieco szerzej niż szerokość barków. Ugnij lekko nogi w kolanach i pochyl się do przodu utrzymując proste plecy. Ściągnij łopatki i przyciągnij sztangę do brzucha bezpośrednio przy nogach, a następnie w taki sam sposób opuść sztangę.\nUtrzymuj proste plecy, nie wyginaj pleców w łuk. Ruch wykonuj poprzez przyciągnięcie łokci do tułowia i wykonuj go powoli.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 20610));
    await db.insert(Exercise(
        name: "Wyciąg dolny",
        description: "Oprzyj stopy na platformie i ugnij lekko kolana. Plecy powinny być proste. Ściągnij łopatki i przyciągnij uchwyt do siebie, w kierunku brzucha. Zepnij mięśnie grzbietu i zatrzymaj ruch a moment, a następnie kontrolowanym ruchem wróć do pozycji początkowej.\nRuch wykonuj z pleców, a nie z ramion i staraj się utrzymywać proste plecy.",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 4226));
    await db.insert(Exercise(
        name: "Martwy ciąg",
        description: "Stań w półprzysiadzie, trzymając sztangę na szerokość barków, plecy powinny być proste. Unieś sztangę równocześnie prostując kolana i biodra. Sztangę prowadź blisko nóg nie  wyginaj pleców. Zatrzymaj ruch na moment spinając mięśnie brzucha i pośladków, a następnie powoli odstaw sztangę na ziemię. ",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 18948));
    await db.insert(Exercise(
        name: "Hantla za głowę",
        description: "Połóż się na ławeczce. Hantla jest trzymana oburącz, a ramiona są prostopadle do podłogi. Powoli opuść hantle za głowę, łokcie utrzymuj lekko zgięte. Kiedy poczujesz rozciąganie w klatce piersiowej zacznij wracać do pozycji wyjściowej.\nNapij mięśnie brzucha i klatkę piersiową. Ruch wykonuj powoli.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 36880));
    await db.insert(Exercise(
        name: "Pompki",
        description: "Ustaw się w pozycji podporu przodem. Dłonie ustaw na wysokości barków, nieco szerzej niż ich szerokość. Powoli opuść ciało w dół, uginając ręce w łokciach, a następnie dynamicznie wróć do pozycji wyjściowej.\nUtrzymuj proste plecy, nie wyginaj ich w łuk, a wzrok trzymaj skierowany w dół. ",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 40976));
    await db.insert(Exercise(
        name: "Rozpiętki hantlami",
        description: "Połóż się na ławeczce, ramiona ustaw na szerokość barków, prostopadle do podłogi. Handle powinny być do siebie prostopadłe. Powolnym ruchem rozłóż ramiona, a następnie zacznij unosić hantle z powrotem do pozycji wyjściowej. \nUnikaj przeprostu w łokciach.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 4112));
    await db.insert(Exercise(
        name: "Rozpiętki - maszyna",
        description: "Plecy oprzyj o oparcie, złap za uchwyty - ramiona powinny być równoległe do podłogi. Przyciągnij ramiona do siebie, mocno napinając klatkę piersiową. Zatrzymaj się na chwilę, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 4112));
    await db.insert(Exercise(
        name: "Pompki na poręczach",
        description: "Chwyć za poręcze i unieś ciało prostując ramiona. Pochyl się lekko do przodu i zginając ręce w łokciach zejdź w dół, a następnie wyprostuj ramiona, wracając do pozycji wyjściowej.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 32784));
    await db.insert(Exercise(
        name: "Wyciskanie",
        description: "Połóż się na ławeczce, chwyć sztangę nachwytem. Opuść sztangę do środkowej części klatki piersiowej, uginając ramiona w łokciach. Zatrzymaj się na moment, a następnie unieś sztangę do pozycji wyjściowej. \nStaraj się nie wyginać nadgarstków, nie doprowadź do przeprostu w łokciach.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 36880));
    await db.insert(Exercise(
        name: "Wyciskanie hantli",
        description: "Połóż się na ławeczce, ramiona ustaw na szerokość barków, prostopadle do podłogi, nadgarstki ustaw tak, aby kciuki były do siebie skierowane. Powolnym ruchem opuść hantle w kierunku środka klatki piersiowej, a następnie wypchnij je do góry, wracając do pozycji wyjściowej.\nStaraj się nie wyginać nadgarstków, nie doprowadź do przeprostu w łokciach.",
        bodyPart: 2,
        isEmbedded: true,
        imageHash: 36880));
    await db.insert(Exercise(
        name: "T raise hantlami",
        description: "Stopy ustaw na szerokość bioder, pochyl się do przodu ręce powinny być luźno opuszczone pod barkami, nogi lekko ugięte w kolanach. Ściągnij łopatki i unieś ręce w bok. Zatrzymaj ruch na moment, a następnie powoli opuść ramiona do pozycji wyjściowej.\nUtrzymuj proste plecy, nie wyginaj ich w łuk. Ruch wykonuj powoli.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 20480));
    await db.insert(Exercise(
        name: "Cuban press",
        description: "Pozycja stojąca, ręce opuszczone wzdłuż ciała. Unieś ręce w bok na wysokość barków, utrzymując kąt prosty w łokciach. Obróć ręce o 180°, nie zmieniając kąta w łokciach, a następnie wypchnij hantle nad głowę prostując ramiona. Potem opuść hantle analogicznie do ich podnoszenia, jednak wolniej.\nNie unoś barków i trzymaj łopatki złączone.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 20480));
    await db.insert(Exercise(
        name: "Przyciąganie liny",
        description: "Stań w lekkim rozkroku, twarzą do wyciągu. Złap oburącz za linę do ćwiczeń, ramiona unieś przed siebie z łokciami skierowanymi na zewnątrz. Ściągnij łopatki i przyciągnij linę w kierunku twarzy, kierując łokcie na boki. Zatrzymaj ruch na moment, a następnie wróć do pozycji wyjściowej.\nNie unoś barków, a w trakcie ruchu nie odchylaj ciała.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 20544));
    await db.insert(Exercise(
        name: "Front raise",
        description: "Stań w lekkim rozkroku, hantle trzymaj przed sobą, oburącz. Unieś hantle przed siebie, nieco ponad linie barków, a następnie opuść ciężar w dół. \nNie kołysz tułowiem i nie zarzucaj ciężarem.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 4096));
    await db.insert(Exercise(
        name: "Żołnierskie",
        description: "Stan w lekkim rozkroku, plecy powinny być proste. Chwyć sztangę nachwytem, nieco szerzej niż szerokość barków i utrzymuj ja na wysokości obojczyków. Wypchnij sztangę nad głowę, łokcie prowadząc przodem, a następnie opuść sztangę do pozycji wyjściowej.\nNie doprowadzaj do przeprostu w łokciach, a ciężaru nie wybijaj z nóg.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 4096));
    await db.insert(Exercise(
        name: "Barki na maszynie",
        description: "Usiądź na siedzeniu i złap za uchwyty. Unieś ramiona i zatrzymaj się na moment, a następnie opuść ręce wracając do pozycji wyjściowej.",
        bodyPart: 3,
        isEmbedded: true,
        imageHash: 4096));
    await db.insert(Exercise(
        name: "Przysiad bułgarski",
        description: "Stań przed ławeczką, tyłem do niej (bliżej - działa bardziej na mięsień czworogłowy uda, dalej na pośladki). Jedną nogę oprzyj na ławeczce. Ręce opuszczone wzdłuż tułowia. Zrób przysiad w taki sposób, aby kolano nogi wykrocznej nieznacznie wysunąć w przód (dla pośladków kolano pozostaje nad stopą). Zejdź w dół, aż udo znajdzie się poniżej kolana, a następnie wróć do pozycji wyjściowej.\nNie pochylaj się i unikaj przeprostu w kolanie.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 2820));
    await db.insert(Exercise(
        name: "Przysiad ze sztangą",
        description: "Stan w rozkroku ze sztangą na plecach. Wykonaj przysiad starając się utrzymać sztangę w jednej linii, a następnie wróć do pozycji wyjściowej.\nUnikaj przeprostu w kolanach, trzymaj plecy proste i nie bujaj tułowiem.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 2048));
    await db.insert(Exercise(
        name: "Wyprosty kolan",
        description: "Wykonaj dynamiczny wyprost kolan, unikając przeprostu, a następnie zegnij nogi do pozycji wyjściowej. ",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 2048));
    await db.insert(Exercise(
        name: "Leg press",
        description: "Plecy oprzyj o oparcie, nogi ustaw na platformie w lekkim rozkroku z palcami skierowanymi na zewnątrz. Wolno opuść ciężar, zginając nogi do kąta prostego w kolanie, a następnie wypchnij ciężar unikając przeprostu.\nLepiej nie prostować nóg do końca, ale uniknąć przeprostu.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 2560));
    await db.insert(Exercise(
        name: "Hip adduction",
        description: "Usiądź i oprzyj plecy na maszynie, nogi w kolanach pod kątem prostym i oprzyj o poduszki maszyny. Złącz nogi i zatrzymaj się na moment, a następnie powoli wróć do pozycji wyjściowej.\nNie pochylaj się za bardzo do przodu.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 1));
    await db.insert(Exercise(
        name: "Cable kickback",
        description: "Stań przodem do wyciągu, pochyl się lekko do przodu, a ręce oprzyj o maszynę. Wypchnij jedną nogę do tyłu, zatrzymaj się na moment, a następnie powoli wróć do pozycji wyjściowej.\nUtrzymuj proste plecy, nie wyginaj ich w łuk. Do ćwiczenia możesz użyć opaski na kostkę lub zapiąć linkę wyciągu do sznurówki.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 516));
    await db.insert(Exercise(
        name: "Hip abduction",
        description: "Usiądź i oprzyj plecy na maszynie, nogi w kolanach pod kątem prostym i oprzyj o poduszki maszyny. Rozsuń nogi i zatrzymaj się na moment, a następnie powoli wróć do pozycji wyjściowej.\nNie pochylaj się za bardzo do przodu.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 516));
    await db.insert(Exercise(
        name: "Good morning",
        description: "Pozycja stojąca, sztanga ułożona na mięśniach czworobocznych grzbietu, nogi minimalnie ugięte. Pochyl się do przodu, zginając się w biodrach i wypychając biodra do tyłu, a następnie wyprostuj się w biodrach, wracając do pozycji wyjściowej.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 516));
    await db.insert(Exercise(
        name: "Hip thrust",
        description: "Usiądź na ziemi przed ławeczką opierając się plecami o ławkę. Nogi trzymaj w lekkim rozkroku, a sztangę ułóż na biodrach. Unieś biodra do góry i przytrzymaj w tej pozycji, a następnie powoli wróć do pozycji wyjściowej. W momencie zatrzymania w kolanach powinien być kąt 90°.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 2564));
    await db.insert(Exercise(
        name: "Zginanie nóg",
        description: "Połóż się na maszynie, wałek powinien znajdować się trochę powyżej łydek. Ugnij nogi w kolanach, przyciągając wałek w stronę ud. Zatrzymaj się na moment, a następnie przyciągnij palce stóp do siebie i powoli wyprostuj nogi wracając do pozycji wyjściowej.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 512));
    await db.insert(Exercise(
        name: "Ławka rzymska",
        description: "Nogi ustaw na podstawkach z palcami skierowanymi na zewnątrz. Podpórki powinny znajdować się poniżej kości biodrowych, aby ćwiczenie uderzało w pośladki. Zaokrąglij plecy, przyciągając brodę do klatki piersiowej. Wykonaj skłon, a następnie wróć do pozycji wyjściowej.\nUnikaj przeprostu w plecach - nie prostuj się do samego końca.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 772));
    await db.insert(Exercise(
        name: "Wspięcia na suwnicy",
        description: "Ustaw stopy na dole platformy - tak aby pięta wystawała poza platformę. Wypchnij platformę, stając na palcach, zatrzymaj się na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 8));
    await db.insert(Exercise(
        name: "Wspięcia ze sztangą",
        description: "Stań na podwyższeniu tak, aby pięta wystawała poza podwyższenie. Ułóż sztangę na plecach. Wespnij się na place, zatrzymaj na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 8));
    await db.insert(Exercise(
        name: "Wspięcia na maszynie",
        description: "Oprzyj stopy na platformie  tak, aby pięta wystawała poza platformę. Wespnij się na place, zatrzymaj na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 4,
        isEmbedded: true,
        imageHash: 8));
    await db.insert(Exercise(
        name: "Prostowanie ramion",
        description: "Stań przodem do wyciągu. Złap oburącz za linę do ćwiczeń, łokcie trzymając przy ciele. Wyprostuj ręce w łokciach, ruch powinien być wykonywany tylko w łokciu. Przy całkowitym wyproście zatrzymaj się na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 32768));
    await db.insert(Exercise(
        name: "Wyciskanie francuskie",
        description: "Połóż się na ławeczce, sztangę unieś nad klatkę piersiową, ramiona powinny być prostopadłe do podłoża. Zegnij ręce w łokciach, opuszczając sztangę do czoła, a następnie wyprostuj ręce, wracając do pozycji wyjściowej.",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 32768));
    await db.insert(Exercise(
        name: "Wąskie pompki",
        description: "Przyjmij pozycję podporu przodem, dłonie rozstaw na szerokość braków. Powoli opuść ciało w dół, uginając ręce w łokciach, a następnie dynamicznie wróć do pozycji wyjściowej.\nUtrzymuj proste plecy, nie wyginaj ich w łuk, a wzrok trzymaj skierowany w dół. ",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 36880));
    await db.insert(Exercise(
        name: "Modlitewnik",
        description: "Pozycja siedząca na modlitewniku, łokcie  na szerokość barków oparte o podpórkę, plecy wyprostowane. Złap sztangę podchwytem, zegnij ręce w łokciach do samego końca, zatrzymaj się a moment, a następnie wyprostuj ręce wracając do pozycji wyjściowej.\nNie odrywaj łokci od podpórki, unikaj przeprostu.",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 2));
    await db.insert(Exercise(
        name: "Zginanie przedramion",
        description: "Stań w rozkroku, łokcie trzymaj blisko tułowia, sztanga trzymana podchwytem w wyprostowanych rękach. Zegnij ręce unosząc sztangę na wysokość barków, zatrzymaj się na moment, a następnie wyprostuj ręce wracając do pozycji wyjściowej.\nNie zarzucaj ciężarem.",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 2));
    await db.insert(Exercise(
        name: "Hammer curl",
        description: "Pozycja stojąca z hantlami w rękach wzdłuż tułowia. Zegnij przedramiona w łokciach w pełnym zakresie, zatrzymaj się a moment, a następnie wyprostuj ręce wracając do pozycji wyjściowej.\nNie zarzucaj ciężarem.",
        bodyPart: 5,
        isEmbedded: true,
        imageHash: 2));
    await db.insert(Exercise(
        name: "Nożyce",
        description: "Połóż się, z ramionami wzdłuż tułowia, broda powinna dotykać klatki piersiowej. Unieś nogi pod kątem 45° i wykonuj naprzemienne wymachy góra-dół. Mięśnie brzucha powinny być cały czas napięte.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 8224));
    await db.insert(Exercise(
        name: "Allachy",
        description: "Klęknij przed wyciągiem, chwyć linę oburącz nad głową. Zrób skłon, spinając mięśnie, a następnie powoli wróć do pozycji wyjściowej.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 8224));
    await db.insert(Exercise(
        name: "Brzuszki",
        description: "Połóż się z nogami ugiętymi w kolanach, ze stopami na podłodze. Ugnij tułów i unieś klatkę piersiową do góry, zatrzymaj się na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 32));
    await db.insert(Exercise(
        name: "Unoszenie nóg",
        description: "Podeprzyj się na przedramionach na stojaku, plecy oprzyj na oparciu. Podnieś nogi na góry, napinając mięśnie brzucha, do momentu, kiedy miednica uniesie się górę. Wtedy zatrzymaj się na moment, a następnie powoli opuść nogi, wracając do pozycji wyjściowej.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 32));
    await db.insert(Exercise(
        name: "Plank",
        description: "Ustaw się w pozycji podporu przodem na przedramionach. Ściągnij łopatki, napnij mięśnie brzucha. Utrzymuj tą pozycje przez określony czas. Plecy trzymaj prosto.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 74016));
    await db.insert(Exercise(
        name: "Sięganie do kostek",
        description: "Połóż się z nogami ugiętymi w kolanach, ze stopami na podłodze. Odrywając łopatki od maty, zegnij  tułów w bok i sięgnij lewą dłonią do lewej kostki. Wróć do pozycji wyjściowej, łopatki wraz z górną częścią pleców pozostawiając w powietrzu. Powtórz ruch na drugą stronę.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 8224));
    await db.insert(Exercise(
        name: "Świeca",
        description: "Połóż się, z ramionami wzdłuż tułowia. Ugnij nogi w kolanach i przyciągnij do siebie tak, aby uda były prostopadle do podłoża. Następnie wyprostuj nogi odrywając biodra od maty, unieś nogi, ustawiając ciało prostopadle do podłoża. Zatrzymaj się na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 32));
    await db.insert(Exercise(
        name: "Zginanie tułowia",
        description: "Usiądź na maszynie i chwyć uchwyty. Ugnij tułów do przodu, napinając mięśnie brzucha. Zatrzymaj się na moment, a następnie wróć do pozycji wyjściowej.",
        bodyPart: 6,
        isEmbedded: true,
        imageHash: 32));


    await db.insert(Training(
        name: "Trening nóg",
        description: "jak ja go kurde nienawidze",
        isEmbedded: true));
    await db.insert(Training(
        name: "Trening pleców",
        description: "ten już lepszy",
        isEmbedded: false));

    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 1, repetitions: 10, weight: 0.0));
    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 1, repetitions: 12, weight: 0.0));
    await db.insert(
        ExerciseSet(trainingID: 2, exerciseID: 1, repetitions: 8, weight: 0.0));

    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 2, repetitions: 10, weight: 80.0));
    await db.insert(ExerciseSet(
        trainingID: 2, exerciseID: 2, repetitions: 8, weight: 80.0));

    await db.insert(ExerciseSet(
        trainingID: 1, exerciseID: 6, repetitions: 12, weight: 50.0));
    await db.insert(ExerciseSet(
        trainingID: 1, exerciseID: 6, repetitions: 10, weight: 60.0));
    await db.insert(ExerciseSet(
        trainingID: 1, exerciseID: 6, repetitions: 10, weight: 70.0));
    await db.insert(ExerciseSet(
        trainingID: 1, exerciseID: 6, repetitions: 8, weight: 80.0));

    await db.insert(FinishedTraining(
        name: "Historyczny",
        description: "Bardzo dawny trening",
        finishedDateTime: DateTime(2023, 2, 30, 12, 30, 0)));
    await db.insert(FinishedTraining(
        name: "Aktualny",
        description: "Trening zrobiony podczas budowania bazy",
        finishedDateTime: DateTime.now()));

    await db.insert(
        History(trainingID: 2, exerciseID: 1, repetitions: 10, weight: 0.0));
    await db.insert(
        History(trainingID: 2, exerciseID: 1, repetitions: 12, weight: 0.0));
    await db.insert(
        History(trainingID: 2, exerciseID: 1, repetitions: 8, weight: 0.0));

    await db.insert(
        History(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(
        History(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(
        History(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 80.0));
    await db.insert(
        History(trainingID: 2, exerciseID: 2, repetitions: 8, weight: 80.0));

    await db.insert(
        History(trainingID: 1, exerciseID: 6, repetitions: 12, weight: 50.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 6, repetitions: 10, weight: 60.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 6, repetitions: 10, weight: 70.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 6, repetitions: 8, weight: 80.0));

    await db.insert(
        History(trainingID: 1, exerciseID: 3, repetitions: 12, weight: 20.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 3, repetitions: 10, weight: 25.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 3, repetitions: 10, weight: 30.0));
    await db.insert(
        History(trainingID: 1, exerciseID: 3, repetitions: 8, weight: 35.0));
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
