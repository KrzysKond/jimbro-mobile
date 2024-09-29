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
  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
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
        iconTheme: const IconThemeData(color: Colors.white),
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
                headerBuilder: (context, date) {
                  String formatedDate = "${_getMonthName(_selectedDate.month)} ${_selectedDate.day}, ${_selectedDate.year}";                  return Container(
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
                    color: Colors.grey.shade200,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.grey.shade600,
                        width: 2
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        title: Text(
                          workouts[index].title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            letterSpacing: 0.5,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              workouts[index].username,
                              style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (workouts[index].photoUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  workouts[index].photoUrl!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
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
          Navigator.pushNamed(context, Routes.addWorkout).then((_){
            _fetchWorkouts(_selectedDate.toIso8601String());
          });
        },
        backgroundColor: Colors.purpleAccent,
        tooltip: 'Add Today\'s Workout',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
