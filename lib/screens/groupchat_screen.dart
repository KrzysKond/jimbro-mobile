import 'package:flutter/material.dart';
import 'package:jimbro_mobile/models/message.dart';
import '../service/groupchat_service.dart';

class GroupChatScreen extends StatefulWidget {
  final int groupId;

  GroupChatScreen({required this.groupId});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late GroupChatService chatService;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    chatService = GroupChatService(
      groupId: widget.groupId,
    );
    _fetchMessages();
    _initializeMessages();
  }

  Future<void> _fetchMessages() async{
    try{
      List<Message> fetchedMessages = await chatService.fetchMessages();
      setState(() {
        messages = fetchedMessages;
      });
      print(messages[0].content);
    }catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _initializeMessages() async {
    chatService.onMessageReceived = (message) {
      print("New message received in screen: $message");
      setState(() {
        messages.add(message);
      });
    };
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      chatService.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    chatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Room',
          style: TextStyle(
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      messages[index].content,
                      style: TextStyle(color: Colors.white),
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
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
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
