import 'package:shaptif/db/TableObject.dart';

class BodyPart extends TableObject{
  String name="";

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
class BodyPartDatabaseSetup
{
  static final String tableName = "BodyPart";
  static final String id = "BodyPart_id";
  static final String name = "name";

  static final List<String> valuesToRead = [name];
}