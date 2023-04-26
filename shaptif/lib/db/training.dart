import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';

class Training extends TableObject
{
  late String name;
  late String description;

  @override
  Training.fromJson ({required Map<String, Object?> json})
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
  
}