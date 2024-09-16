import 'package:flutter/material.dart';
import 'chat_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Map<String, String>> _contacts = [
    {"name": "John Doe", "message": "Hello, how are you?"},
    {"name": "Jane Smith", "message": "Let's meet tomorrow!"}
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _addContact() {
    setState(() {
      _contacts.add({
        "name": _nameController.text,
        "message": _messageController.text
      });
    });

    _nameController.clear();
    _messageController.clear();

    Navigator.pop(context);
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: "Message"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: const Color.fromARGB(255, 142, 3, 3),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 155, 1, 1),
              child: Text(_contacts[index]['name']![0]),
            ),
            title: Text(_contacts[index]['name']!),
            subtitle: Text(_contacts[index]['message']!),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteContact(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(contactName: _contacts[index]['name']!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: const Color.fromARGB(255, 140, 2, 2),
        child: const Icon(Icons.add),
      ),
    );
  }
}
