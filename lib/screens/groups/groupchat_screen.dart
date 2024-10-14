import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jimbro_mobile/models/message.dart';
import '../../common/format_timestap.dart';
import '../../service/groupchat_service.dart';

class GroupChatScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  GroupChatScreen({required this.groupId, required this.groupName});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late GroupChatService chatService;
  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    chatService = GroupChatService(
      groupId: widget.groupId,
    );
    _fetchMessages();
    _initializeMessages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
        _fetchMoreMessages();
      }
    });
  }

  Future<void> _fetchMessages() async {
    try {
      List<Message> fetchedMessages = await chatService.fetchMessages(currentPage);
      setState(() {
        messages = fetchedMessages.reversed.toList();
        currentPage++;
      });
      _scrollToBottom();
      if (messages.isNotEmpty) {
        print(messages[0].content);
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> _fetchMoreMessages() async {
    if (isLoadingMore) return;
    isLoadingMore = true;

    try {
      List<Message> fetchedMessages = await chatService.fetchMessages(currentPage);
      setState(() {
        messages.insertAll(0, fetchedMessages.reversed);
        currentPage++;
      });
    } catch (e) {
      print('Error fetching more messages: $e');
    } finally {
      isLoadingMore = false;
    }
  }

  void _initializeMessages() async {
    chatService.onMessageReceived = (message) {
      print("New message received in screen: $message");
      setState(() {
        messages.add(message);
      });
      _scrollToBottom();
    };
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      chatService.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    chatService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.white70;
    final textColor = Theme.of(context).primaryColor;
    const subtitleColor = Colors.white54;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.senderName ?? '',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message.content,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message.timestamp != null
                                ? formatTimestamp(message.timestamp!)
                                : '',
                            style: TextStyle(color: subtitleColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: subtitleColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: textColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: textColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: textColor),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: primaryColor),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
