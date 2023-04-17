class Excercise {
  final int? id;
  final String name;
  final String description;

  const Excercise({this.id, required this.name, required this.description});

  Map<String, Object?> toJson() =>
      {
        ExcerciseDatabaseSetup.id: id,
        ExcerciseDatabaseSetup.name: name,
        ExcerciseDatabaseSetup.description: description,
      };

  Excercise copy({int? id, String? name, String? description}) =>
      Excercise(id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description);

  static Excercise fromJson(Map<String, Object?> json) =>
      Excercise(id: json[ExcerciseDatabaseSetup.id] as int?,
          name: json[ExcerciseDatabaseSetup.name] as String,
          description: json[ExcerciseDatabaseSetup.description] as String);

}
class ExcerciseDatabaseSetup
{
  static final String tableName = "Exercise";
  static final String id = "excercise_id";
  static final String name = "name";
  static final String description = "description";

  static final List<String> valuesToRead = [name, description];
}