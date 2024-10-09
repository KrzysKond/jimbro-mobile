import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jimbro_mobile/models/message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class GroupChatService {
  final int groupId;
  late final WebSocketChannel channel;
  late String _webSocketUrl;

  late Function(Message message) onMessageReceived;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  GroupChatService({required this.groupId}) {
    _initialize();
  }

  Future<void> _initialize() async {
    List<Message> messages = [];
    String? token = await _secureStorage.read(key: 'auth_token');
    messages = await fetchMessages();
    _webSocketUrl = 'ws://10.0.2.2:8000/ws/chat/$groupId/?token=$token';
    _connect();
  }

  Future<List<Message>> fetchMessages() async {
    List<Message> messages = [];
    try {
      String? token = await _secureStorage.read(key: 'auth_token');

      if (token == null) {
        print('No token found');
        return messages;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/chat/group-messages/$groupId/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final decodedJson = json.decode(decodedResponse);

        // Access the 'data' list from the response
        if (decodedJson['status'] == true && decodedJson['data'] != null) {
          final List<dynamic> jsonData = decodedJson['data'];
          print('Fetched JSON data: $jsonData');
          messages = jsonData.map((item) => Message.fromJson(item)).toList();
        } else {
          print('No messages found or "data" key missing.');
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }

    return messages;
  }

  void _connect() {
    channel = IOWebSocketChannel.connect(_webSocketUrl);

    channel.stream.listen(
          (message) {
        _handleMessage(message);
      },
      onDone: () {
        print('WebSocket closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  void _handleMessage(String message) {
    try {
      final data = json.decode(message);
      Message receivedMessage = Message.fromJson(data);
      print('Received message: ${receivedMessage.content}');
      onMessageReceived(receivedMessage);
    } catch (e) {
      print('Error decoding message: $e');
    }
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      final data = {
        'content': message,
      };
      channel.sink.add(json.encode(data));
      print('Message sent: $data');
    }
  }

  void dispose() {
    channel.sink.close();
  }
}
