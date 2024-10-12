import 'package:flutter/material.dart';
import '../../common/format_timestap.dart';
import '../../models/comment.dart';
import '../../service/api_comment_service.dart';

class CommentsScreen extends StatefulWidget {
  final int workoutId;
  final String? workoutPhotoURL;
  final String workoutTitle;

  CommentsScreen({required this.workoutId, required this.workoutPhotoURL, required this.workoutTitle});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comment> comments = [];
  bool isLoading = true;
  bool isTimedOut = false;

  @override
  void initState() {
    super.initState();
    _startTimeout();
    _fetchComments();
  }

  void _startTimeout() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && comments.isEmpty) {
        setState(() {
          isTimedOut = true;
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchComments() async {
    try {
      comments = await ApiCommentService().fetchComments(widget.workoutId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.workoutTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (widget.workoutPhotoURL != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.workoutPhotoURL!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                if (comments.isEmpty && isTimedOut)
                  Center(
                    child: Text(
                      'No comments yet.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      Comment comment = comments[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.grey[100],
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.authorName,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    comment.createdAt != null
                                        ? formatTimestamp(comment.createdAt!)
                                        : '',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment.text,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
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
      ),
    );
  }
}
