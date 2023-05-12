import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/database_manager.dart';

class ExerciseSet extends TableObject
{
  @override
  int? id;
  late int trainingID;
  late int exerciseID;
  late int repetitions;
  late double weight;
  String? exerciseName;
  bool completed = false;

  Future<String> getExerciseName()
  async
  {
    return exerciseName ??= (await DatabaseManger.instance.selectExercise( id! )).name;
  }

  @override
  ExerciseSet.fromJson(Map<String, Object?> json)
  {
    {
      id= json[ExerciseSetDatabaseSetup.id] as int?;
      trainingID= json[ExerciseSetDatabaseSetup.trainingID] as int;
      exerciseID= json[ExerciseSetDatabaseSetup.exerciseID] as int;
      repetitions= json[ExerciseSetDatabaseSetup.repetitions] as int;
      weight= json[ExerciseSetDatabaseSetup.weight] as double;
      exerciseName = json[ExerciseSetDatabaseSetup.exerciseName] as String;
    }
  }

  @override
  ExerciseSet({this.id, required this.trainingID, required this.exerciseID, required this.repetitions, required this.weight});

  @override
  ExerciseSet copy({required int returnedId}) =>
      ExerciseSet(id: returnedId,
          trainingID: trainingID,
          exerciseID: exerciseID,
          repetitions: repetitions,
          weight: weight
      );

  @override
  String getIdName() {
    return ExerciseSetDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return ExerciseSetDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return ExerciseSetDatabaseSetup.valuesToRead;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        ExerciseSetDatabaseSetup.id: id,
        ExerciseSetDatabaseSetup.trainingID: trainingID,
        ExerciseSetDatabaseSetup.exerciseID: exerciseID,
        ExerciseSetDatabaseSetup.repetitions: repetitions,
        ExerciseSetDatabaseSetup.weight: weight,
      };

}