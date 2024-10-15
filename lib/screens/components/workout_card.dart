import 'package:flutter/material.dart';

import '../comments/comments_screen.dart';
import '../../service/api_workout_service.dart';

class WorkoutCard extends StatefulWidget {
  final int id;
  final String title;
  final String username;
  final String? photoUrl;
  final bool isLiked;
  final int fires;
  final int commentsCount;

  const WorkoutCard({
    Key? key,
    required this.id,
    required this.title,
    required this.username,
    this.photoUrl,
    required this.isLiked,
    required this.fires,
    required this.commentsCount,
  }) : super(key: key);

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late bool _isLiked;
  late int _fires;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _fires = widget.fires;
  }

  Future<void> _toggleLike() async {
    try {
      await ApiWorkoutService().toggleLike(widget.id);
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
          title: Text(
            widget.title,
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
                widget.username,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.photoUrl!,
                    width: double.infinity,
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
                            workoutId: widget.id,
                            workoutPhotoURL: widget.photoUrl,
                            workoutTitle: widget.title,
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
                  Text('${widget.commentsCount}', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
