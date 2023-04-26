import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:shaptif/db/body_part.dart';
import 'package:shaptif/db/training.dart';
import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/set.dart';
import 'package:shaptif/db/setup.dart';
import 'dart:io';

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
    FOREIGN KEY(${ExerciseDatabaseSetup.bodyPart}) REFERENCES ${BodyPartDatabaseSetup.tableName} (${BodyPartDatabaseSetup.id})
    )
    ''');

    await db.execute('''
    CREATE TABLE ${TrainingDatabaseSetup.tableName} ( 
    ${TrainingDatabaseSetup.id} $idType, 
    ${TrainingDatabaseSetup.name} $textType,
    ${TrainingDatabaseSetup.description} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${SetDatabaseManager.tableName} ( 
    ${SetDatabaseManager.id} $idType, 
    ${SetDatabaseManager.trainingID} $intType,
    ${SetDatabaseManager.exerciseID} $intType,
    ${SetDatabaseManager.repetitions} $intType,
    ${SetDatabaseManager.weight} $doubleType,
    FOREIGN KEY(${SetDatabaseManager.trainingID}) REFERENCES ${TrainingDatabaseSetup.tableName} (${TrainingDatabaseSetup.id}),
    FOREIGN KEY(${SetDatabaseManager.exerciseID}) REFERENCES ${ExerciseDatabaseSetup.tableName} (${ExerciseDatabaseSetup.id})
    )
    ''');
  }

  Future<TableObject> insert(TableObject object) async {
    final db = await instance.database;

    final id = await db.insert(object.getTableName(), object.toJson());
    return object.copy(id: id);
  }

  Future<Exercises> selectExercises(int id) async {
    final row = await select(id, ExerciseDatabaseSetup.tableName,
        ExerciseDatabaseSetup.id, ExerciseDatabaseSetup.valuesToRead);

    return Exercises.fromJson(row);
  }

  Future<BodyPart> selectBodyPart(int id) async {
    final row = await select(id, BodyPartDatabaseSetup.tableName,
        BodyPartDatabaseSetup.id, BodyPartDatabaseSetup.valuesToRead);

    return BodyPart.fromJson(row);
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

  Future<List<Exercises>> selectAllExercises() async {
    final db = await instance.database;
    return (await db.query(ExerciseDatabaseSetup.tableName,
            orderBy: "${ExerciseDatabaseSetup.name} ASC"))
        .map((json) => Exercises.fromJson(json))
        .toList();
  }

  Future<List<BodyPart>> selectAllBodyParts() async {
    final db = await instance.database;
    return (await db.query(BodyPartDatabaseSetup.tableName,
            orderBy: "${BodyPartDatabaseSetup.name} ASC"))
        .map((json) => BodyPart.fromJson(json))
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

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;

    return await db.delete(
      ExerciseDatabaseSetup.tableName,
      where: '${ExerciseDatabaseSetup.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllExercises() async {
    final db = await instance.database;

    return await db.delete(ExerciseDatabaseSetup.tableName);
  }

  Future executeRawQuery(String query) async {
    final db = await instance.database;

    await db.execute(query);
  }

  Future initialData() async {
    final db = instance;
    await db.insert(BodyPart(name: "plecy"));
    await db.insert(BodyPart(name: "klatka piersiowa"));
    await db.insert(BodyPart(name: "barki"));
    await db.insert(BodyPart(name: "nogi"));
    await db.insert(BodyPart(name: "rece"));
    await db.insert(BodyPart(name: "brzuch"));

    await db.insert(Exercises(
        name: "Podciąganie", description: "pod chwytem tylko", category: 1));
    await db.insert(
        Exercises(name: "Wiosłowanie", description: "czuje ze zyje", category: 1));
    await db
        .insert(Exercises(name: "Modlitewnik", description: "+", category: 5));
    await db
        .insert(Exercises(name: "Klatka płaska", description: "+", category: 2));
    await db
        .insert(Exercises(name: "Szruksy", description: "+", category: 3));
    await db
        .insert(Exercises(name: "Przysiady", description: "+", category: 4));
    await db
        .insert(Exercises(name: "Allachy", description: "+", category: 6));

    await db.insert(Training(name: "Trening nóg", description: "jak ja go kurde nienawidze"));
    await db.insert(Training(name: "Trening street", description: "lorem imsum"));
    await db.insert(Training(name: "Trening pleców", description: "lorem imsum dolore"));

    await db.insert(Set(trainingID: 2, exerciseID: 1, repetitions: 10, weight: 0.0));
    await db.insert(Set(trainingID: 2, exerciseID: 1, repetitions: 12, weight: 0.0));
    await db.insert(Set(trainingID: 2, exerciseID: 1, repetitions: 8, weight: 0.0));

    await db.insert(Set(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(Set(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 70.0));
    await db.insert(Set(trainingID: 2, exerciseID: 2, repetitions: 10, weight: 80.0));
    await db.insert(Set(trainingID: 2, exerciseID: 2, repetitions: 8, weight: 80.0));

    await db.insert(Set(trainingID: 1, exerciseID: 6, repetitions: 12, weight: 50.0));
    await db.insert(Set(trainingID: 1, exerciseID: 6, repetitions: 10, weight: 60.0));
    await db.insert(Set(trainingID: 1, exerciseID: 6, repetitions: 10, weight: 70.0));
    await db.insert(Set(trainingID: 1, exerciseID: 6, repetitions: 8, weight: 80.0));

  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
