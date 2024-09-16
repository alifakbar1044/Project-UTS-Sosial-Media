import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String contactName;

  const ChatPage({super.key, required this.contactName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    _prefs = await SharedPreferences.getInstance();
    final String? messagesJson = _prefs.getString(widget.contactName);
    if (messagesJson != null) {
      final List<dynamic> messagesList = json.decode(messagesJson);
      setState(() {
        _messages.addAll(messagesList.map((msg) => Map<String, String>.from(msg)));
      });
    }
  }

  Future<void> _saveMessages() async {
    final String messagesJson = json.encode(_messages);
    await _prefs.setString(widget.contactName, messagesJson);
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({
        "message": _messageController.text,
        "sender": "Me"
      });
    });

    _saveMessages(); // Save messages after adding a new one

    // Clear the text field after sending
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.contactName}'),
        backgroundColor: const Color.fromARGB(255, 167, 1, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'Me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color.fromARGB(255, 162, 1, 1).withOpacity(0.8) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color.fromARGB(255, 148, 0, 0),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
