import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
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
          icon: const Icon(Icons.group, size: 40, color: Colors.white),
          onPressed: () {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
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
              EasyInfiniteDateTimeLine(
                focusDate: _selectedDate,
                firstDate: DateTime(2023,1,1),
                lastDate: DateTime.now(),
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                    _fetchWorkouts(_selectedDate.toIso8601String());
                  });
                },
                locale: 'en_ISO',

                dayProps: const EasyDayProps(
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffE0E0E0), // Light gray for inactive days
                    ),
                  ),
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purpleAccent, // Lighter purple for active day
                          Color(0xff8E44AD), // Darker purple
                        ],
                      ),
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffE0E0E0), // Light gray for inactive days
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ListTile(
                      title: Text(workouts[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(workouts[index].username),
                          if (workouts[index].photoUrl != null)
                            Image.network(workouts[index].photoUrl!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
