class BodyPartDatabaseSetup
{
  static const String tableName = "BodyPart";
  static const String id = "body_part_id";
  static const String name = "name";

  static final List<String> valuesToRead = [name];
}

class ExerciseDatabaseSetup
{
  static const String tableName = "Exercise";
  static const String id = "exercise_id";
  static const String name = "name";
  static const String description = "description";
  static const String bodyPart = "bodyPart";

  static final List<String> valuesToRead = [name, description, bodyPart];
}

class SetDatabaseSetup
{
  static const String tableName = "janusz";
  static const String id = "set_id";
  static const String trainingID = TrainingDatabaseSetup.id;
  static const String exerciseID = ExerciseDatabaseSetup.id;
  static const String repetitions = "repetitions";
  static const String weight = "weight";

  static final List<String> valuesToRead = [trainingID,exerciseID,repetitions,weight];
}

class TrainingDatabaseSetup
{
  static const String tableName = "Training";
  static const String id = "training_id";
  static const String name = "name";
  static const String description = "description";

  static final List<String> valuesToRead = [name, description];
}