import 'package:flutter/material.dart';
import '../../models/comment.dart';
import '../../service/api_comment_service.dart';

class AddCommentScreen extends StatefulWidget {
  final int workoutId;
  final String? workoutImageUrl;
  final String title;

  AddCommentScreen({
    required this.workoutId,
    required this.title,
    this.workoutImageUrl,
  });

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _addComment() async {
    String text = _commentController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Comment cannot be empty.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiCommentService().addComment(widget.workoutId, text);
      Navigator.pop(context, text);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding comment: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add a Comment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            widget.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (widget.workoutImageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.workoutImageUrl!,
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
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write your comment here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _addComment,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
