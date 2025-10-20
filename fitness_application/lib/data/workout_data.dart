import 'package:fitness_application/data/hive_database.dart';
import 'package:fitness_application/models/exercise.dart';
import 'package:fitness_application/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /*
    Workout data structure
    - This overall list contains multiple workouts
    - Each workout has a name and a list of exercises
   */
  List<Workout> workoutList = [
    Workout(
      name: 'Full Body Workout',
      exercises: [
        Exercise(
          name: 'Push Ups', 
          weight: '-', 
          reps: '15', 
          sets: '3',
        ),
        Exercise(
          name: 'Pull Ups', 
          weight: '-', 
          reps: '10', 
          sets: '3',
        ),
        Exercise(
          name: 'Plank', 
          weight: '-', 
          reps: '60 seconds', 
          sets: '3',
        ),
        Exercise(
          name: 'Burpees', 
          weight: '-', 
          reps: '12', 
          sets: '3',
        ),
      ],
    ),
    Workout(
      name: 'Leg Day',
      exercises: [
        Exercise(
          name: 'Squats', 
          weight: '-', 
          reps: '20', 
          sets: '4',
        ),
        Exercise(
          name: 'Lunges', 
          weight: '-', 
          reps: '15', 
          sets: '3',
        ),
        Exercise(
          name: 'Calf Raises', 
          weight: '-', 
          reps: '25', 
          sets: '4',
        ),
      ],
    ),
  ];

  // if there there are workouts already in database, then get that workout list,otherwise use the default workout list
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
  }
  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }
  //get the length of a given workout
  int getNumberOfExcercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }
  //add a workout
  void addWorkout(String name) {
    workoutList.add(
      Workout(name: name, exercises: []),
    );
    notifyListeners();
    db.saveToDatabase(workoutList);
  }
  //add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );
    notifyListeners();
    db.saveToDatabase(workoutList);
  } 
  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
  }
  
  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }
  //return relevant exercise object, given a workout name and exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
  }
}