import 'package:fitness_application/Components/exercise_tile.dart';
import 'package:fitness_application/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}
class _WorkoutPageState extends State<WorkoutPage> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //create new exercise
  void createNewExercise() {
    final TextEditingController exerciseNameController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    final TextEditingController setsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: exerciseNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter exercise name',
                  labelText: 'Exercise Name',
                ),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  hintText: 'Enter weight',
                  labelText: 'Weight (kg)',
                ),
              ),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(
                  hintText: 'Enter number of reps',
                  labelText: 'Reps',
                ),
              ),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(
                  hintText: 'Enter number of sets',
                  labelText: 'Sets',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (exerciseNameController.text.isNotEmpty &&
                    weightController.text.isNotEmpty &&
                    repsController.text.isNotEmpty &&
                    setsController.text.isNotEmpty) {
                  Provider.of<WorkoutData>(context, listen: false)
                      .addExercise(
                    widget.workoutName,
                    exerciseNameController.text,
                    weightController.text,
                    repsController.text,
                    setsController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.workoutName),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewExercise,
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: value.getNumberOfExcercisesInWorkout(widget.workoutName),
            itemBuilder: (context, index) {
              final exercise = value.getRelevantWorkout(widget.workoutName).exercises[index];
              return ExerciseTile(
                exerciseName: exercise.name,
                weight: exercise.weight,
                reps: exercise.reps,
                sets: exercise.sets,
                isCompleted: exercise.isCompleted,
                onCheckBoxChanged: (isChecked) { onCheckBoxChanged(widget.workoutName, exercise.name); },
              );
            },
          ),
        );
      },
    );
  }
}