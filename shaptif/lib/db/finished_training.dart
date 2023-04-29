import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/training.dart';

import 'database_manager.dart';

class FinishedTraining extends Training
{
  late DateTime finishedDateTime /*= DateTime(2000, 1, 1, 12, 0, 0, 0)*/;

  FinishedTraining({id, required super.name, required super.description, required this.finishedDateTime});

  FinishedTraining.fromJson(Map<String, Object?> json) : super.fromJson(json)
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

  @override
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