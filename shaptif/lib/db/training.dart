import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/set.dart';
import 'package:shaptif/db/database_manager.dart';

class Training extends TableObject
{
  late String name;
  late String description;
  List<MySet> sets = [];
  Map <String, List<MySet>> exercisesMap = <String, List<MySet>>{};

  Future initExerciseMap() async
  {
    sets = (await DatabaseManger.instance.selectSetsByTraining(id!));
    for(var s in sets) {
      if(!exercisesMap.containsKey(s.exerciseName))
      {
        List<MySet> temp = [s];
        exercisesMap[s.exerciseName!] = temp;
      }
      else
      {
        exercisesMap[s.exerciseName!]!.add(s);
      }
    }
  }

  @override
  Training.fromJson(Map<String, Object?> json)
  {
    {
      id= json[TrainingDatabaseSetup.id] as int?;
      name= json[TrainingDatabaseSetup.name] as String;
      description= json[TrainingDatabaseSetup.description] as String;
    }
  }

  @override
  Training({id, required this.name, required this.description});

  @override
  Training copy({int? id}) =>
      Training(id: id ?? id,
          name: name,
          description: description
      );

  @override
  String getIdName() {
    return TrainingDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return TrainingDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return TrainingDatabaseSetup.valuesToRead;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        TrainingDatabaseSetup.id: id,
        TrainingDatabaseSetup.name: name,
        TrainingDatabaseSetup.description: description,
      };

  Future<List<MySet>> getSets()
  async {
    if(sets.isEmpty)
    {
      sets = (await DatabaseManger.instance.selectSetsByTraining(id!));
      for(var s in sets) {
        await s.getExerciseName();
      }
    }
    return sets;
  }


}