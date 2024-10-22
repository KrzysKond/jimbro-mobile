import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jimbro_mobile/models/member.dart';
import 'package:jimbro_mobile/models/workout.dart';
import 'package:jimbro_mobile/screens/components/workout_card.dart'; // Import your WorkoutCard
import 'package:jimbro_mobile/routes.dart';
import 'package:jimbro_mobile/service/api_user_data.dart';
import 'package:jimbro_mobile/service/api_workout_service.dart';


class ProfileScreen extends StatefulWidget {
  final int? user_id;

  ProfileScreen({required this.user_id});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  Member? user;
  List<Workout> workouts = [];
  List<DateTime> workoutsDates = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts(widget.user_id);
    _fetchUser(widget.user_id);
  }

  Future<void> _fetchUser(int? user_id) async{
    try {
      Member? fetchedUser = await ApiUserService().fetchUserData(user_id);
      setState(() {
        user = fetchedUser;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _fetchWorkouts(int? user_id) async {
    try {
      List<Workout> fetchedWorkouts = await ApiWorkoutService().fetchLastWeekWorkouts(user_id);
      setState(() {
        workouts = fetchedWorkouts;
        workoutsDates = fetchedWorkouts.map((workout) => workout.date).toList();
      });
    } catch (e) {
      print('Error fetching workouts: $e');
    }
  }

  bool hasWorkout(DateTime date) {
    return workoutsDates.any((workoutDate) =>
    workoutDate.year == date.year &&
        workoutDate.month == date.month &&
        workoutDate.day == date.day);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  user?.name ?? '',
                  style: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: (user == null || user!.profilePicture == null)
                        ? Colors.blue
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (user != null && user!.profilePicture != null)
                        ? NetworkImage(user!.profilePicture!)
                        : null,
                    child: (user == null || user!.profilePicture == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.white) // Default icon
                        : null,
                  ),
                ),

                const SizedBox(height: 50),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Workouts Last Week',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      DateTime day = DateTime.now().subtract(Duration(days: 6 - index));
                      bool workoutExists = hasWorkout(day);
          
                      return Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: workoutExists ? Colors.green : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
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
    );
  }
}
