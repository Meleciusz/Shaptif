import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';

class Set extends TableObject
{
  late int trainingID;
  late int exerciseID;
  late int repetitions;
  late double weight;

  @override
  Set.fromJson ({required Map<String, Object?> json})
  {
    {
      id= json[SetDatabaseManager.id] as int?;
      trainingID= json[SetDatabaseManager.trainingID] as int;
      exerciseID= json[SetDatabaseManager.exerciseID] as int;
      repetitions= json[SetDatabaseManager.repetitions] as int;
      weight= json[SetDatabaseManager.weight] as double;
    }
  }

  @override
  Set({id, required this.trainingID, required this.exerciseID, required this.repetitions, required this.weight});

  @override
  Set copy({int? id}) =>
      Set(id: id ?? id,
          trainingID: trainingID,
          exerciseID: exerciseID,
          repetitions: repetitions,
          weight: weight
      );

  @override
  String getIdName() {
    return SetDatabaseManager.id;
  }

  @override
  String getTableName() {
    return SetDatabaseManager.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return SetDatabaseManager.valuesToRead;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        SetDatabaseManager.id: id,
        SetDatabaseManager.trainingID: trainingID,
        SetDatabaseManager.exerciseID: exerciseID,
        SetDatabaseManager.repetitions: repetitions,
        SetDatabaseManager.weight: weight,
      };

}