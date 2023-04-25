import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shaptif/db/Exercise.dart';
import 'package:shaptif/db/Category.dart';
import 'package:shaptif/db/TableObject.dart';
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
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final intType = 'INTEGER';

    await db.execute('PRAGMA foreign_keys = ON;');

    await db.execute('''
    CREATE TABLE ${BodyPartDatabaseSetup.tableName} ( 
    ${BodyPartDatabaseSetup.id} $idType, 
    ${BodyPartDatabaseSetup.name} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE ${ExcerciseDatabaseSetup.tableName} ( 
    ${ExcerciseDatabaseSetup.id} $idType, 
    ${ExcerciseDatabaseSetup.name} $textType,
    ${ExcerciseDatabaseSetup.description} $textType,
    ${ExcerciseDatabaseSetup.bodyPart} $intType,
    FOREIGN KEY(${ExcerciseDatabaseSetup.bodyPart}) REFERENCES ${BodyPartDatabaseSetup.tableName} (${BodyPartDatabaseSetup.id})
    )
    ''');
  }

  Future<TableObject> insert(TableObject excercise) async {
    final db = await instance.database;

    final id = await db.insert(excercise.getTableName(), excercise.toJson());
    return excercise.copy(id: id);
  }

  Future<Excercise> selectExcercise(int id) async {
    final maps = await select(id, ExcerciseDatabaseSetup.tableName,
        ExcerciseDatabaseSetup.id, ExcerciseDatabaseSetup.valuesToRead);

    return Excercise.fromJson(maps);
  }

  Future<BodyPart> selectBodyPart(int id) async {
    final maps = await select(id, BodyPartDatabaseSetup.tableName,
        BodyPartDatabaseSetup.id, BodyPartDatabaseSetup.valuesToRead);

    return BodyPart.fromJson(maps);
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

  Future<List<Excercise>> selectAllExcercise() async {
    final db = await instance.database;
    return (await db.query(ExcerciseDatabaseSetup.tableName,
            orderBy: "${ExcerciseDatabaseSetup.name} ASC"))
        .map((json) => Excercise.fromJson(json))
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

//Should be delete implemented for BodyPart?
  Future<int> deleteExcercise(int id) async {
    final db = await instance.database;

    return await db.delete(
      ExcerciseDatabaseSetup.tableName,
      where: '${ExcerciseDatabaseSetup.id} = ?',
      whereArgs: [id],
    );
  }

  void deleteAllExcercises() async {
    final db = await instance.database;

    await db.delete(ExcerciseDatabaseSetup.tableName);
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

    await db.insert(Excercise(
        name: "Podciąganie", description: "pod chwytem tylko", category: 1));
    await db.insert(
        Excercise(name: "Wiosłowanie", description: "czuje ze zyje", category: 1));
    await db
        .insert(Excercise(name: "Modlitewnik", description: "+", category: 5));
    await db
        .insert(Excercise(name: "Klatka płaska", description: "+", category: 2));
    await db
        .insert(Excercise(name: "Szruksy", description: "+", category: 3));
    await db
        .insert(Excercise(name: "Przysiady", description: "+", category: 4));
    await db
        .insert(Excercise(name: "Allachy", description: "+", category: 6));
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
