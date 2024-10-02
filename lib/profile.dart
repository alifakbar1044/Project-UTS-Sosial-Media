import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lingtan/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String phoneNumber = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  File? _image; // Variabel untuk menyimpan gambar yang dipilih

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final imagePath = prefs.getString('profile_image');
      if (imagePath != null) {
        _image = File(imagePath);
      }
      username = prefs.getString('username') ?? 'Username';
      email = prefs.getString('email') ?? ''; // Bersihkan tampilan email
      phoneNumber = prefs.getString('phoneNumber') ?? ''; // Bersihkan tampilan phone number
      usernameController.text = username;
      emailController.text = email;
      phoneNumberController.text = phoneNumber;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phoneNumber', phoneNumberController.text);
    // Update local state
    setState(() {
      username = usernameController.text;
      email = emailController.text;
      phoneNumber = phoneNumberController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 5, 5),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ContactsPage(),
              ),
              (route) => false,
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            ClipOval(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // Jika gambar dipilih, tampilkan
                      : AssetImage('assets/akbar.png'), // Gambar default
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              username,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0), // Red text
                fontSize: 24,
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 8),
            // Email and phone section with bold text and better layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Phone number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: const Color.fromARGB(255, 6, 0, 0),
                      ),
                      SizedBox(width: 8),
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, // Bold font
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 8),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, // Bold font
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Edit Username',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Red label
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Edit Email',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Red label
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Edit Phone Number',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Red label
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Warna latar belakang tombol
                      foregroundColor: Colors.white, // Ubah warna teks tombol menjadi putih
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
