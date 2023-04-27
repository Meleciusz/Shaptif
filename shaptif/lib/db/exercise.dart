import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/setup.dart';

class Exercise extends TableObject{

  late String name;
  late String description;
  late int bodyPart;
  String? bodyPartString;

  @override
  Exercise({id, required this.name, required this.description, required this.bodyPart});

  @override
  Exercise.fromJson(Map<String, Object?> json)
  {
      id= json[ExerciseDatabaseSetup.id] as int?;
      name= json[ExerciseDatabaseSetup.name] as String;
      description= json[ExerciseDatabaseSetup.description] as String;
      bodyPart= json[ExerciseDatabaseSetup.bodyPart] as int;
      bodyPartString= json[ExerciseDatabaseSetup.bodyPartString] as String;
  }

  Future<String> getCategoryString()
  async
  {
    return bodyPartString ??= (await DatabaseManger.instance.selectBodyPart( bodyPart)).name;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        ExerciseDatabaseSetup.id: id,
        ExerciseDatabaseSetup.name: name,
        ExerciseDatabaseSetup.description: description,
        ExerciseDatabaseSetup.bodyPart: bodyPart,
      };

  @override
  Exercise copy({int? id}) =>
      Exercise(id: id ?? id,
          name: name,
          description: description,
          bodyPart: bodyPart
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