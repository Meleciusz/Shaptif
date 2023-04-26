abstract class TableObject{
  TableObject.fromJson ({required Map<String, Object?> json});
  TableObject();

  Map<String, Object?> toJson();
  TableObject copy({int? id});

  int? id;

  String getTableName();
  String getIdName();
  //It isn't used anywhere
  //Probably will be removed
  List<String> getValuesToRead();
}

