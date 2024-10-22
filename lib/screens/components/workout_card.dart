import 'package:flutter/material.dart';
import 'package:jimbro_mobile/models/workout.dart';

import '../../models/member.dart';
import '../../service/api_user_data.dart';
import '../comments/comments_screen.dart';
import '../../service/api_workout_service.dart';
import '../profile/profile_screen.dart';

class WorkoutCard extends StatefulWidget {
  final Workout workout;


  const WorkoutCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  Member? user;
  late bool _isLiked;
  late int _fires;
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.workout.isLiked;
    _fires = widget.workout.fires;
    _fetchUserPhoto(widget.workout.userId);
  }

  Future<void> _fetchUserPhoto(int? user_id) async{
    try {
      String? profilePic = await ApiUserService().fetchUserPicture(user_id);
      setState(() {
         profilePicture = profilePic;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _toggleLike() async {
    try {
      await ApiWorkoutService().toggleLike(widget.workout.id);
      setState(() {
        if (_isLiked) {
          _isLiked = false;
          _fires -= 1;
        } else {
          _isLiked = true;
          _fires += 1;
        }
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade600, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5, width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user_id: widget.workout.userId),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: (profilePicture != null)
                            ? NetworkImage(profilePicture!)
                            : null,
                        child: (profilePicture == null)
                            ? const Icon(Icons.person, size: 30, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                          widget.workout.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                    ],
                  ),
                )
              ),
              Text(
                widget.workout.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.workout.photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.workout.photoUrl!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.whatshot : Icons.whatshot_outlined,
                      color: _isLiked ? Colors.red[800] : Colors.black54,
                      size: 40,
                    ),
                    onPressed: _toggleLike,
                  ),
                  const SizedBox(width: 5),
                  Text('$_fires', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            workoutId: widget.workout.id,
                            workoutPhotoURL: widget.workout.photoUrl,
                            workoutTitle: widget.workout.title,
                            onCommentAdded: () {
                              setState(() {
                                widget.workout.commentsCount += 1;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.comment,
                      size: 40,
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('${widget.workout.commentsCount}', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
