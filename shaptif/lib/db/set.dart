import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/database_manager.dart';

class MySet extends TableObject
{
  late int trainingID;
  late int exerciseID;
  late int repetitions;
  late double weight;
  bool completed = false;
  String? exerciseName;

  Future<String> getExerciseName()
  async
  {
    return exerciseName ??= (await DatabaseManger.instance.selectExercise( id! )).name;
  }

  @override
  MySet.fromJson(Map<String, Object?> json)
  {
    {
      id= json[SetDatabaseSetup.id] as int?;
      trainingID= json[SetDatabaseSetup.trainingID] as int;
      exerciseID= json[SetDatabaseSetup.exerciseID] as int;
      repetitions= json[SetDatabaseSetup.repetitions] as int;
      weight= json[SetDatabaseSetup.weight] as double;
      exerciseName = json[SetDatabaseSetup.exerciseName] as String;
    }
  }

  @override
  MySet({id, required this.trainingID, required this.exerciseID, required this.repetitions, required this.weight});

  @override
  MySet copy({int? id}) =>
      MySet(id: id ?? id,
          trainingID: trainingID,
          exerciseID: exerciseID,
          repetitions: repetitions,
          weight: weight
      );

  @override
  String getIdName() {
    return SetDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return SetDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return SetDatabaseSetup.valuesToRead;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        SetDatabaseSetup.id: id,
        SetDatabaseSetup.trainingID: trainingID,
        SetDatabaseSetup.exerciseID: exerciseID,
        SetDatabaseSetup.repetitions: repetitions,
        SetDatabaseSetup.weight: weight,
      };

}