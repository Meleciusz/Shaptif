import 'dart:convert';

import 'package:shaptif/db/table_object.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/setup.dart';

class Exercise extends TableObject{
  @override
  int? id;
  late String name;
  late String description;
  late int bodyPart;
  late int imageHash;
  bool isEmbedded = false;
  String? bodyPartString;

  @override
  Exercise({this.id, required this.name, required this.description, required this.bodyPart, required this.isEmbedded, this.imageHash = 0});

  @override
  Exercise.fromJson(Map<String, Object?> json)
  {
      id = json[ExerciseDatabaseSetup.id] as int?;
      name = json[ExerciseDatabaseSetup.name] as String;
      description = json[ExerciseDatabaseSetup.description] as String;
      bodyPart = json[ExerciseDatabaseSetup.bodyPart] as int;
      isEmbedded = json[ExerciseDatabaseSetup.isEmbedded] == 1;
      imageHash = json[ExerciseDatabaseSetup.imageHash] as int;
      bodyPartString = json[ExerciseDatabaseSetup.bodyPartString] as String;
  }

  String toQR()
  {
    var json =
    {
      'n':name,
      'd':description,
      'b':bodyPart,
      'i':imageHash,
    };

    return jsonEncode(json);
  }

  static Exercise? fromQR(String jsonString)
  {
    String? name;
    String? description;
    int? bodyP;
    int? hash;
    try
    {
      Map<String, dynamic> exercise = jsonDecode(jsonString);
      name = exercise['n'] as String?;
      description = exercise['d'] as String?;
      bodyP = exercise['b'] as int?;
      hash = exercise['i'] as int?;
    }
    catch(e)
    {
      return null;
    }
    if(name != null && description != null && bodyP !=null && hash!=null)
      return Exercise(name: name, description: description, bodyPart: bodyP, isEmbedded: false, imageHash: hash);
    else
      return null;
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
        ExerciseDatabaseSetup.imageHash: imageHash,
        ExerciseDatabaseSetup.isEmbedded: isEmbedded ? 1 : 0,
      };

  @override
  Exercise copy({required int returnedId}) =>
      Exercise(id: returnedId,
          name: name,
          description: description,
          bodyPart: bodyPart,
          isEmbedded: isEmbedded,
          imageHash: imageHash,
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

  Future<bool> canBeDeleted() async
  {
    return await DatabaseManger.instance.isExerciseInDB(id!);
  }

  Map<String, bool> imageHashToMap() {
    int index = BodyPartImages.names.length - 1;
    String binaryString =
    imageHash.toRadixString(2).padLeft(BodyPartImages.names.length, '0');
    return Map.fromIterable(
      BodyPartImages.names,
      key: (str) => str,
      value: (str) => binaryString[index--] == '1' ? true : false,
    );
  }

}