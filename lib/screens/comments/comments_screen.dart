import 'package:flutter/material.dart';
import '../../common/format_timestap.dart';
import '../../models/comment.dart';
import '../../service/api_comment_service.dart';

class CommentsScreen extends StatefulWidget {
  final int workoutId;
  final String? workoutPhotoURL;
  final String workoutTitle;

  CommentsScreen({
    required this.workoutId,
    required this.workoutPhotoURL,
    required this.workoutTitle,
  });

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comment> comments = [];
  bool isLoading = true;
  bool isTimedOut = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  TextEditingController _commentController = TextEditingController();

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
      setState(() {
        isLoading = false;
        isTimedOut = true;
      });
    }
  }

  void _postComment() async {
    String text = _commentController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Comment cannot be empty.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ApiCommentService().addComment(widget.workoutId, text);
      setState(() {
        comments.add(Comment(
          text: text,
          authorName: 'You',
          createdAt: DateTime.now(),
        ));
        _commentController.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding comment: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    widget.workoutTitle,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
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
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(color: Colors.red),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (comments.isEmpty && isTimedOut)
                            Center(
                              child: Text(
                                'No comments yet. Be the first to comment!',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          if (comments.isNotEmpty)
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
                                              formatTimestamp(comment.createdAt!),
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
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isSubmitting ? Icons.hourglass_top : Icons.post_add,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        onPressed: _isSubmitting ? null : _postComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
