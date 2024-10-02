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

  String selectedConversation = 'Percakapan 1';
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _populateSampleMessages();
  }

  void _populateSampleMessages() {
    setState(() {
      _messages.clear();
      if (selectedConversation == 'Percakapan 1') {
        _messages.addAll([
          {"message": "Halo, tugas UAS kita dikumpulkan kapan ya?", "sender": "Me"},
          {"message": "Sepertinya deadline-nya minggu depan, tanggal 30 September.", "sender": "Ivan"},
          {"message": "Oh oke, jadi kita punya waktu seminggu lagi buat ngerjain.", "sender": "Me"},
          {"message": "Iya, tapi lebih baik diselesaikan secepatnya supaya nggak mepet deadline.", "sender": "Ivan"}
        ]);
      } else if (selectedConversation == 'Percakapan 2') {
        _messages.addAll([
          {"message": "Bagaimana progress tugas kita?", "sender": "Me"},
          {"message": "Aku baru mulai coding backend, gimana dengan kamu?", "sender": "Ivan"},
          {"message": "Aku sudah selesai desain UI, tinggal implementasi.", "sender": "Me"},
          {"message": "Keren, nanti kasih update lagi ya!", "sender": "Ivan"}
        ]);
      }
    });
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
      _messages.add({"message": _messageController.text, "sender": "Me"});
    });

    _saveMessages();
    _messageController.clear();
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ukuran Font"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (double size in [12.0, 14.0, 16.0, 18.0, 20.0, 24.0])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fontSize = size;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          size.toString(),
                          style: TextStyle(fontSize: size, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/${widget.contactName.toLowerCase()}.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text('${widget.contactName}'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onSelected: (String newValue) {
              setState(() {
                selectedConversation = newValue;
                _populateSampleMessages();
              });
            },
            itemBuilder: (BuildContext context) {
              return <String>['Percakapan 1', 'Percakapan 2'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_size, color: Colors.black),
            onPressed: _showFontSizeDialog,
          ),
        ],
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
                      style: TextStyle(fontSize: _fontSize),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
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
