class BodyPartDatabaseSetup
{
  static const String tableName = "BodyPart";
  static const String id = "body_part_id";
  static const String name = "name";

  static final List<String> valuesToRead = [id, name];
}

class ExerciseDatabaseSetup
{
  static const String tableName = "Exercise";
  static const String id = "exercise_id";
  static const String name = "name";
  static const String description = "description";
  static const String bodyPart = "bodyPart";
  static const String isEmbedded = "is_embedded";
  static const String imageHash = "image_hash";
  static const String bodyPartString = "bodyPartString";

  static const String selectString = '''
    SELECT 
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.id} AS ${ExerciseDatabaseSetup.id},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.name} AS ${ExerciseDatabaseSetup.name},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.description} AS ${ExerciseDatabaseSetup.description}, 
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.bodyPart} AS ${ExerciseDatabaseSetup.bodyPart},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.isEmbedded} AS ${ExerciseDatabaseSetup.isEmbedded},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.imageHash} AS ${ExerciseDatabaseSetup.imageHash},
    ${BodyPartDatabaseSetup.tableName}.${BodyPartDatabaseSetup.name} AS ${ExerciseDatabaseSetup.bodyPartString}
    FROM ${ExerciseDatabaseSetup.tableName}
    JOIN ${BodyPartDatabaseSetup.tableName}
    ON ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.bodyPart} == ${BodyPartDatabaseSetup.tableName}.${BodyPartDatabaseSetup.id}
    ''';

  static final List<String> valuesToRead = [id, name, description, bodyPart, isEmbedded];
}

class ExerciseSetDatabaseSetup
{
  static const String tableName = "ExerciseSet";
  static const String id = "set_id";
  static const String trainingID = TrainingDatabaseSetup.id;
  static const String exerciseID = ExerciseDatabaseSetup.id;
  static const String repetitions = "repetitions";
  static const String weight = "weight";
  static const String exerciseName = "exerciseName";
  static const String selectString = '''
    SELECT 
    ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.id} AS ${ExerciseSetDatabaseSetup.id},
    ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.trainingID} AS ${ExerciseSetDatabaseSetup.trainingID},
    ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.exerciseID} AS ${ExerciseSetDatabaseSetup.exerciseID}, 
    ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.repetitions} AS ${ExerciseSetDatabaseSetup.repetitions},
    ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.weight} AS ${ExerciseSetDatabaseSetup.weight},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.name} AS ${ExerciseSetDatabaseSetup.exerciseName}
    FROM ${ExerciseSetDatabaseSetup.tableName}
    JOIN ${ExerciseDatabaseSetup.tableName}
    ON ${ExerciseSetDatabaseSetup.tableName}.${ExerciseSetDatabaseSetup.exerciseID} == ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.id}
    ''';

  static final List<String> valuesToRead = [id, trainingID,exerciseID,repetitions,weight];
}

class TrainingDatabaseSetup
{
  static const String tableName = "Training";
  static const String id = "training_id";
  static const String name = "name";
  static const String description = "description";
  static const String isEmbedded = "is_embedded";

  static final List<String> valuesToRead = [id, name, description, isEmbedded];
}

class FinishedTrainingDatabaseSetup
{
  static const String tableName = "Finished_Training";
  static const String id = "finished_training_id";
  static const String name = "name";
  static const String description = "description";
  static const String finishedDateTime = "finishedDateTime";

  static final List<String> valuesToRead = [id, name, description, finishedDateTime];
}

class HistoryDatabaseSetup
{
  static const String tableName = "History";
  static const String id = "history_id";
  static const String trainingID = FinishedTrainingDatabaseSetup.id;
  static const String exerciseID = ExerciseDatabaseSetup.id;
  static const String repetitions = "repetitions";
  static const String weight = "weight";
  static const String exerciseName = "exerciseName";
  static const String selectString = '''
    SELECT 
    ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.id} AS ${HistoryDatabaseSetup.id},
    ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.trainingID} AS ${HistoryDatabaseSetup.trainingID},
    ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.exerciseID} AS ${HistoryDatabaseSetup.exerciseID}, 
    ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.repetitions} AS ${HistoryDatabaseSetup.repetitions},
    ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.weight} AS ${HistoryDatabaseSetup.weight},
    ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.name} AS ${HistoryDatabaseSetup.exerciseName}
    FROM ${HistoryDatabaseSetup.tableName}
    JOIN ${ExerciseDatabaseSetup.tableName}
    ON ${HistoryDatabaseSetup.tableName}.${HistoryDatabaseSetup.exerciseID} == ${ExerciseDatabaseSetup.tableName}.${ExerciseDatabaseSetup.id}
    ''';

  static final List<String> valuesToRead = [id, trainingID,exerciseID,repetitions,weight];
}

class BodyPartImages
{
  static List<String> names = ["Adductor", "Biceps","Butt","Calf","Chest","CoreAbs","Deltoid","Dorsi","DownAbs","Femoris","Forearm", "Quadriceps","Shoulders","SideAbs","Trapezius","Triceps","UpAbs", "Rest"];
}