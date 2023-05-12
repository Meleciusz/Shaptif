import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/database_manager.dart';

class History extends TableObject
{
  @override
  int? id;
  late int trainingID;
  late int exerciseID;
  late int repetitions;
  late double weight;
  String? exerciseName;

  Future<String> getExerciseName()
  async
  {
    return exerciseName ??= (await DatabaseManger.instance.selectExercise( id! )).name;
  }

  @override
  History.fromJson(Map<String, Object?> json)
  {
    {
      id= json[HistoryDatabaseSetup.id] as int?;
      trainingID= json[HistoryDatabaseSetup.trainingID] as int;
      exerciseID= json[HistoryDatabaseSetup.exerciseID] as int;
      repetitions= json[HistoryDatabaseSetup.repetitions] as int;
      weight= json[HistoryDatabaseSetup.weight] as double;
      exerciseName = json[HistoryDatabaseSetup.exerciseName] as String;
    }
  }

  @override
  History({this.id, required this.trainingID, required this.exerciseID, required this.repetitions, required this.weight});

  @override
  History copy({required int returnedId}) =>
      History(id: returnedId,
          trainingID: trainingID,
          exerciseID: exerciseID,
          repetitions: repetitions,
          weight: weight
      );

  @override
  String getIdName() {
    return HistoryDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return HistoryDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return HistoryDatabaseSetup.valuesToRead;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        HistoryDatabaseSetup.id: id,
        HistoryDatabaseSetup.trainingID: trainingID,
        HistoryDatabaseSetup.exerciseID: exerciseID,
        HistoryDatabaseSetup.repetitions: repetitions,
        HistoryDatabaseSetup.weight: weight,
      };

}