import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';
import 'package:shaptif/db/exercise_set.dart';
import 'package:shaptif/db/database_manager.dart';

class Training extends TableObject
{
  late String name;
  late String description;
  bool isEmbedded = false;
  List<ExerciseSet> sets = [];
  Map <String, List<ExerciseSet>> exercisesMap = <String, List<ExerciseSet>>{};

  Future initExerciseMap() async
  {
    sets = await getSets();
    for(var s in sets) {
      if(!exercisesMap.containsKey(s.exerciseName))
      {
        List<ExerciseSet> tempList = [s];
        exercisesMap[s.exerciseName!] = tempList;
      }
      else
      {
        exercisesMap[s.exerciseName]!.add(s);
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
      isEmbedded = json[TrainingDatabaseSetup.isEmbedded] == 1;
    }
  }

  @override
  Training({id, required this.name, required this.description, required this.isEmbedded});

  @override
  Training copy({int? id}) =>
      Training(id: id ?? id,
          name: name,
          description: description,
          isEmbedded: isEmbedded
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
        TrainingDatabaseSetup.isEmbedded: isEmbedded ? 1 : 0,
      };

  Future<List<ExerciseSet>> getSets()
  async {
    if(sets.isEmpty)
    {
      sets = (await DatabaseManger.instance.selectSetsByTraining(id!));
    }
    return sets;
  }


}