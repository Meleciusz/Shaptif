import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/setup.dart';

class BodyPart extends TableObject{
  late String name;

  BodyPart({id, required this.name});

  @override
  Map<String, Object?> toJson() =>
      {
        BodyPartDatabaseSetup.id: id,
        BodyPartDatabaseSetup.name: name
      };

  @override
  BodyPart copy({int? id/*, String? name, String? description, int? category*/}) =>
      BodyPart(id: id,
          name: name
      );

  @override
  BodyPart.fromJson(Map<String, Object?> json)
  {
    id= json[BodyPartDatabaseSetup.id] as int?;
    name= json[BodyPartDatabaseSetup.name] as String;
  }

  @override
  String getIdName() {
    return BodyPartDatabaseSetup.id;
  }

  @override
  String getTableName() {
    return BodyPartDatabaseSetup.tableName;
  }

  @override
  List<String> getValuesToRead() {
    return BodyPartDatabaseSetup.valuesToRead;
  }

}