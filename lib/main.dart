import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

import 'add_training.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JimBro',
        theme: ThemeData(
        primarySwatch: Colors.purple, // Purple theme
        scaffoldBackgroundColor: Colors.black, // Black background for the app
        textTheme: const TextTheme(
          bodyMedium: const TextStyle(color: Colors.white70, fontSize: 16), // Minimalist text style
          titleLarge: const TextStyle(color: Colors.white), // AppBar title color
          ),
        ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("JIMBRO", style: TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 2),)),
        backgroundColor: Colors.purpleAccent // Darker purple for the AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              const Center(
                child: Text(
                  "Who's gonna carry the boats!?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent, // Purple accent for important text
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Has Kacper slacked?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70, // Minimalist white70 color for regular text
                ),
              ),
              const SizedBox(height: 20),
              CalendarTimeline(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020, 1, 1),
                lastDate: DateTime(2025, 12, 31),
                onDateSelected: (date) => print(date),
                monthColor: Colors.purpleAccent,
                dayColor: Colors.purple[200],
                activeDayColor: Colors.black,
                activeBackgroundDayColor: Colors.purpleAccent,
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTrainingForm page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTrainingForm()),
          );
        },
        backgroundColor: Colors.purpleAccent,
        tooltip: 'Add Today\'s Training', // Tooltip for the FAB
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}