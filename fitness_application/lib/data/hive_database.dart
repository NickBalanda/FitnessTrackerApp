import 'package:fitness_application/datetime/date_time.dart';
import 'package:fitness_application/models/exercise.dart';
import 'package:fitness_application/models/workout.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  //reference our hive box
  final _myBox = Hive.box('workout_database');

  //check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does not exist");
      _myBox.put("START_DATE", getTodayDateYMD());
      return false;
    } else {
      print("previous data exists");
      return true;
    }
  }

  //return start date yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout object to list of strings
    final workoutList = convertObjectToWorkoutList(workouts);
    //convert exercise object to list of list of strings
    final exerciseList = convertObjectToExerciseList(workouts);

    // check if any exercises have been done, put a 0 or 1 for each yyyymmdd date
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_$getTodayDateYMD()", 1);
    }else{
      _myBox.put("COMPLETION_STATUS_$getTodayDateYMD()", 0);
    }
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data, and return a list of workouts
  List<Workout> readFromDatabase(){
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for(int i = 0; i < workoutNames.length; i++){
      List<Exercise> exercisesInEachWorkout = [];
      for(int j = 0; j < exerciseDetails[i].length; j++){
        String name = exerciseDetails[i][j][0];
        String weight = exerciseDetails[i][j][1];
        String reps = exerciseDetails[i][j][2];
        String sets = exerciseDetails[i][j][3];
        bool isCompleted = exerciseDetails[i][j][4] == 'true' ? true : false;
        exercisesInEachWorkout.add(Exercise(name: name, weight: weight, reps: reps, sets: sets,isCompleted: isCompleted));
      }
      Workout workout = Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      mySavedWorkouts.add(workout);
      
    }
    return mySavedWorkouts;
  }

  //check if any excercises have been done
    bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }   
    }
    return false;
  }

  //return completion status of a given date yyyymmdd
  int getCompletionStatus(String ymd) {
    return _myBox.get("COMPLETION_STATUS_$ymd") ?? 0;
  }

}
  //coverts workouts object to list 
  List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }
  return workoutList;
} 
  //converts the exercise list in a workout object into a list of strings
  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /*
      [
        Upper Body Workout
        [
          [exercise name, sets, reps],
          [exercise name, sets, reps],
          ...
        ]
        Lower Body Workout
        [
          [exercise name, sets, reps],
          [exercise name, sets, reps],
          ...
        ]
      
      ]
      */
  ];
  for (int i = 0; i < workouts.length; i++) {
    List<List<String>> singleWorkoutExercises = [];
    for (int j = 0; j < workouts[i].exercises.length; j++) {
      List<String> singleExercise = [];
      singleExercise.add(workouts[i].exercises[j].name);
      singleExercise.add(workouts[i].exercises[j].sets.toString());
      singleExercise.add(workouts[i].exercises[j].reps.toString());
      singleWorkoutExercises.add(singleExercise);
    }
    exerciseList.add(singleWorkoutExercises);
  }
  return exerciseList;
}
