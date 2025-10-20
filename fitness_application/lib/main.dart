import 'package:fitness_application/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async{
  //initialize hive
  await Hive.initFlutter();
  //open a hive box
  await Hive.openBox('workout_database');
  runApp(const MyApp());
}

//https://youtu.be/ZWciJzsPyPs?si=_HwOeEZf7ufauSpe&t=568

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}


