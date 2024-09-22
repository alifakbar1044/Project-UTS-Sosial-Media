import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'delete_kontak.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Map<String, String>> _contacts = [
    {"name": "AVAN", "message": "ada", "image": "assets/avan.png"},
    {"name": "IAN", "message": "ada", "image": "assets/ian.png"},
    {"name": "AKBAR", "message": "ada", "image": "assets/akbar.png"},
    {"name": "CALVIN", "message": "di kampus", "image": "assets/calvin.png"},
    {"name": "ALDI", "message": "ada", "image": "assets/aldi.png"},
    {"name": "DOSEN", "message": "untar"},
    {"name": "FABIAN", "message": "di sekolah", "image": "assets/fabian.png"},
    {"name": "DENNIS", "message": "di rumah"},
    {"name": "RAJA", "message": "di rumah"},
  ];

  List<Map<String, String>> _filteredContacts = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts
            .where((contact) =>
                contact['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _addContact(String name, String message) {
    setState(() {
      _contacts.add({
        "name": name,
        "message": message,
        "image": "assets/default.png"
      });
      _filteredContacts = _contacts;
    });
  }

  void _showDeleteContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteKontakDialog(
          contacts: _contacts,
          onDelete: _deleteContact,
        );
      },
    );
  }

  void _deleteContact(String name) {
    setState(() {
      _contacts.removeWhere((contact) => contact['name'] == name);
      _filteredContacts = _contacts;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddContactDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Kontak"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Kontak"),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: "Pesan Kontak"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _messageController.text.isNotEmpty) {
                  _addContact(_nameController.text, _messageController.text);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Harap isi semua field!")),
                  );
                }
              },
              child: const Text("Tambah"),
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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari Kontak...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 60,
                    child: Image.asset(
                      'assets/lin.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'LINGTAN',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
        backgroundColor: const Color.fromARGB(255, 142, 3, 3),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/pencarian.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchController.clear();
                _filteredContacts = _contacts;
              });
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/kontak.png',
              height: 30,
              width: 30,
            ),
            onPressed: _showDeleteContactDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = _filteredContacts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 155, 1, 1),
                backgroundImage: contact['image'] != null
                    ? AssetImage(contact['image']!)
                    : null,
                child: contact['image'] == null
                    ? Text(
                        contact['name']![0],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              title: Text(
                contact['name']!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                contact['message']!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(contactName: contact['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF910606),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Pembaruan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 172, 4, 4),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
