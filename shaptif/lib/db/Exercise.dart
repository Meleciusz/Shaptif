import 'package:shaptif/db/TableObject.dart';
import 'package:shaptif/db/DatabaseManager.dart';
import 'package:shaptif/db/Category.dart';

class Excercise extends TableObject{

  late String name ;
  String description = "";
  int category = 0;
  String categoryS="";

  @override
  Excercise({id, required this.name, required this.description, required this.category});

  @override
  Excercise.fromJson(Map<String, Object?> json)
  {
      id= json[ExcerciseDatabaseSetup.id] as int?;
      name= json[ExcerciseDatabaseSetup.name] as String;
      description= json[ExcerciseDatabaseSetup.description] as String;
      category= json[ExcerciseDatabaseSetup.bodyPart] as int;
  }

  void getCategoryString()
  async {
    BodyPart c = await DatabaseManger.instance.selectBodyPart( category);
    categoryS = c.name;
  }

  @override
  Map<String, Object?> toJson() =>
      {
        ExcerciseDatabaseSetup.id: id,
        ExcerciseDatabaseSetup.name: name,
        ExcerciseDatabaseSetup.description: description,
        ExcerciseDatabaseSetup.bodyPart: category,
      };

  @override
  Excercise copy({int? id/*, String? name, String? description, int? category*/}) =>
      Excercise(id: id ?? id,
          name: name,
          description: description,
          category: category
      );

  @override
  String getIdName() {
    return ExcerciseDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return ExcerciseDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return ExcerciseDatabaseSetup.valuesToRead;
  }

}
class ExcerciseDatabaseSetup
{
  static final String tableName = "Exercise";
  static final String id = "excercise_id";
  static final String name = "name";
  static final String description = "description";
  static final String bodyPart = "bodyPart";

  static final List<String> valuesToRead = [name, description, bodyPart];
}