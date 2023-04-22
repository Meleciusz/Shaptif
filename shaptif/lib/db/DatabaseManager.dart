import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shaptif/db/Exercise.dart';

class DatabaseManger {
  static final DatabaseManger instance = DatabaseManger._init();

  static Database? _database;

  DatabaseManger._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Shaptif.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE ${ExcerciseDatabaseSetup.tableName} ( 
  ${ExcerciseDatabaseSetup.id} $idType, 
  ${ExcerciseDatabaseSetup.name} $textType,
  ${ExcerciseDatabaseSetup.description} $textType
  )
''');
  }

  Future<Excercise> insertExcercise(Excercise excercise) async {
    final db = await instance.database;

    final id =
        await db.insert(ExcerciseDatabaseSetup.tableName, excercise.toJson());
    return excercise.copy(id: id);
  }

  Future<Excercise> selectExcercise(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      ExcerciseDatabaseSetup.tableName,
      columns: ExcerciseDatabaseSetup.valuesToRead,
      where: '${ExcerciseDatabaseSetup.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Excercise.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Excercise>> selectAllExcercises() async {
    final db = await instance.database;

    final orderBy = '${ExcerciseDatabaseSetup.name} ASC';

    final result =
        await db.query(ExcerciseDatabaseSetup.tableName, orderBy: orderBy);

    return result.map((json) => Excercise.fromJson(json)).toList();
  }

  Future<int> updateExcercise(Excercise ex) async {
    final db = await instance.database;

    return db.update(
      ExcerciseDatabaseSetup.tableName,
      ex.toJson(),
      where: '${ExcerciseDatabaseSetup.id} = ?',
      whereArgs: [ex.id],
    );
  }

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

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
