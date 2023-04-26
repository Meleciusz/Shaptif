import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/setup.dart';

class Exercises extends TableObject{

  late String name;
  late String description;
  late int category;
  String? categoryString;

  @override
  Exercises({id, required this.name, required this.description, required this.category});

  @override
  Exercises.fromJson(Map<String, Object?> json)
  {
      id= json[ExerciseDatabaseSetup.id] as int?;
      name= json[ExerciseDatabaseSetup.name] as String;
      description= json[ExerciseDatabaseSetup.description] as String;
      category= json[ExerciseDatabaseSetup.bodyPart] as int;
  }

  Future<String> getCategoryString()
  async
  {
    return categoryString ??= (await DatabaseManger.instance.selectBodyPart( category)).name;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        ExerciseDatabaseSetup.id: id,
        ExerciseDatabaseSetup.name: name,
        ExerciseDatabaseSetup.description: description,
        ExerciseDatabaseSetup.bodyPart: category,
      };

  @override
  Exercises copy({int? id}) =>
      Exercises(id: id ?? id,
          name: name,
          description: description,
          category: category
      );

  @override
  String getIdName() {
    return ExerciseDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return ExerciseDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return ExerciseDatabaseSetup.valuesToRead;
  }

}