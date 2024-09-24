import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:jimbro_mobile/service/api_workout_service.dart';
import 'package:jimbro_mobile/service/auth_service.dart';
import 'package:jimbro_mobile/routes.dart';
import 'add_workout.dart';
import '../models/workout.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts(_selectedDate.toIso8601String());
  }

  Future<void> _fetchWorkouts(String date) async {
    try {
      List<Workout> fetchedWorkouts = await ApiWorkoutService().fetchWorkouts(date);
      setState(() {
        workouts = fetchedWorkouts;
      });
    } catch (e) {
      print('Error fetching workouts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.group, size: 40, color: Colors.white,),
            onPressed: (){
              Navigator.pushNamed(context, '/group');
            },
        ),
        title: const Text(
          "JIMBRO",
          style: TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 2),
        ),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await AuthService().logout();
              } catch (e) {
                print(e);
              }
              Navigator.pushNamedAndRemoveUntil(context, '/splash', (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              size: 40,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Has Kacper slacked!?",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CalendarTimeline(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020, 1, 1),
                  lastDate: DateTime(2025, 12, 31),
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                      _fetchWorkouts(_selectedDate.toIso8601String());
                    });
                  },
                  monthColor: Colors.purpleAccent,
                  dayColor: Colors.purple[200],
                  activeDayColor: Colors.black,
                  activeBackgroundDayColor: Colors.purpleAccent,
                  locale: 'en_ISO',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                // Print the photoUrl to the console
                print('Workout ${index + 1} Photo URL: ${workouts[index].photoUrl}');

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(workouts[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${workouts[index].username}'),
                        if (workouts[index].photoUrl != null)
                          Image.network(workouts[index].photoUrl!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addWorkout);
        },
        backgroundColor: Colors.purpleAccent,
        tooltip: 'Add Today\'s Workout',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
