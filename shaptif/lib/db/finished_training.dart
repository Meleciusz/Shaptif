import 'package:shaptif/db/history.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/training.dart';

import 'database_manager.dart';

class FinishedTraining extends TableObject
{
  late String name;
  late String description;
  bool isEmbedded = false;
  List sets = [];
  Map <String, List<History>> exercisesMap = <String, List<History>>{};
  late DateTime finishedDateTime /*= DateTime(2000, 1, 1, 12, 0, 0, 0)*/;

  Future initExerciseMap() async
  {
    sets = await getSets();
    for(var s in sets) {
      if(!exercisesMap.containsKey(s.exerciseName))
      {
        List<History> tempList = [s];
        exercisesMap[s.exerciseName!] = tempList;
      }
      else
      {
        exercisesMap[s.exerciseName]!.add(s);
      }
    }
  }

  FinishedTraining({id, required this.name, required this.description, required this.finishedDateTime});

  FinishedTraining.fromJson(Map<String, Object?> json)
  {
    id= json[FinishedTrainingDatabaseSetup.id] as int?;
    name= json[FinishedTrainingDatabaseSetup.name] as String;
    description= json[FinishedTrainingDatabaseSetup.description] as String;
    finishedDateTime = DateTime.parse(json[FinishedTrainingDatabaseSetup.finishedDateTime] as String);
  }

  @override
  Map<String, Object?> toJson() =>
      {
        FinishedTrainingDatabaseSetup.id: id,
        FinishedTrainingDatabaseSetup.name: name,
        FinishedTrainingDatabaseSetup.description: description,
        FinishedTrainingDatabaseSetup.finishedDateTime : finishedDateTime.toIso8601String(),
      };

  Future<List> getSets()
  async {
    if(sets.isEmpty)
    {
      sets = (await DatabaseManger.instance.selectHistoryByTraining(id!));
    }
    return sets;
  }

  @override
  FinishedTraining copy({int? id}) =>
      FinishedTraining(id: id ?? id,
          name: name,
          description: description,
          finishedDateTime: finishedDateTime,
      );

  @override
  String getIdName() {
    return FinishedTrainingDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return FinishedTrainingDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return FinishedTrainingDatabaseSetup.valuesToRead;
  }
  
}