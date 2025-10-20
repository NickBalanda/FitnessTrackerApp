import 'package:fitness_application/data/workout_data.dart';
import 'package:fitness_application/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }
  void createNewWorkout() {
    // Create a text controller for the input field
    final TextEditingController workoutNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Workout'),
          content: TextField(
            controller: workoutNameController,
            decoration: const InputDecoration(
              hintText: 'Enter workout name',
              labelText: 'Workout Name',
            ),
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
                // Add the workout with the entered name
                if (workoutNameController.text.isNotEmpty) {
                  Provider.of<WorkoutData>(context, listen: false)
                      .addWorkout(workoutNameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

  }

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    // Navigation logic to go to the workout page can be implemented here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder:(context, value, child) => Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewWorkout, 
        child: const Icon(Icons.add),
          // Action to add a new workout can be implemented here
      ),
        body: ListView.builder(
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name), 
            ),
          ),
        ),
      ),
    );
  }
}