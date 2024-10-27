import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:jimbro_mobile/screens/components/workout_card.dart';
import 'package:jimbro_mobile/service/api_workout_service.dart';
import 'package:jimbro_mobile/service/auth_service.dart';
import 'package:jimbro_mobile/routes.dart';
import 'add_workout.dart';
import '../models/workout.dart';
import '../models/comment.dart';
import 'comments/comments_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DateTime _selectedDate = DateTime.now();
  List<Workout> workouts = [];

  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
  @override
  void initState() {
    super.initState();
    _fetchWorkouts(_selectedDate.toIso8601String());
    _firebaseMessaging.getToken().then((token) => print(token));
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
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, Routes.settings);
            }, icon: const Icon(Icons.settings, size: 30),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                EasyInfiniteDateTimeLine(
                  focusDate: _selectedDate,
                  firstDate: DateTime(2023, 1, 1),
                  lastDate: DateTime.now(),
                  onDateChange: (date) {
                    setState(() {
                      _selectedDate = date;
                      _fetchWorkouts(_selectedDate.toIso8601String());
                    });
                  },
                  locale: 'en_ISO',
                  headerBuilder: (context, date) {
                    String formatedDate = "${_getMonthName(_selectedDate.month)} ${_selectedDate.day}, ${_selectedDate.year}";
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatedDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  dayProps: EasyDayProps(
                    todayStyle: const DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xffE0E0E0),
                      ),
                    ),
                    dayStructure: DayStructure.dayStrDayNum,
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                    ),
                    inactiveDayStyle: const DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xffE0E0E0),
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
                    Workout workout = workouts[index];
                    return WorkoutCard(
                      workout: workout,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addWorkout).then((_) {
            _fetchWorkouts(_selectedDate.toIso8601String());
          });
        },
        tooltip: 'Add Today\'s Workout',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}
