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
        name: "Podciąganie",
        description: "pod chwytem tylko",
        bodyPart: 1,
        isEmbedded: true));
    await db.insert(Exercise(
        name: "Wiosłowanie",
        description: "czuje ze zyje",
        bodyPart: 1,
        isEmbedded: true,
        imageHash: 3));
    await db.insert(Exercise(
        name: "Modlitewnik", description: "+", bodyPart: 5, isEmbedded: true));
    await db.insert(Exercise(
        name: "Klatka płaska",
        description: "+",
        bodyPart: 2,
        isEmbedded: true));
    await db.insert(Exercise(
        name: "Szruksy", description: "+", bodyPart: 3, isEmbedded: true));
    await db.insert(Exercise(
        name: "Przysiady", description: "+", bodyPart: 4, isEmbedded: true));
    await db.insert(Exercise(
        name: "Allachy", description: "+", bodyPart: 6, isEmbedded: true));

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
