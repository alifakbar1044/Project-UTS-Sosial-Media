import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingtan/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? _image;
  String? username;
  String status = "nature will never stop providing calm and comfort";

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('username');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final savedImage = await _saveImageToLocalDirectory(File(pickedFile.path));
      setState(() {
        _image = savedImage;
      });
      _saveImagePath(savedImage.path);
    }
  }

  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<File> _saveImageToLocalDirectory(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final time = '${now.year}${_formatTwoDigits(now.month)}${_formatTwoDigits(now.day)}_${_formatTwoDigits(now.hour)}${_formatTwoDigits(now.minute)}${_formatTwoDigits(now.second)}';

    final imagePath = '${directory.path}/profile_image_$time.png';
    final savedImage = await image.copy(imagePath);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('profile_image', savedImage.path);
    return savedImage;
  }

  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', path);
    setState(() {});
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Widget buildItem({
    required String text,
    required IconData iconData,
    required Color iconColor,
    VoidCallback? onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 213, 213, 213),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemContent({
    required String text,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: buildItem(
        text: text,
        iconData: iconData,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          CupertinoButton(
            onPressed: () {},
            child: Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.black,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/lingtan.png') as ImageProvider,
                ),
                SizedBox(height: 20),
                Text(
                  username ?? 'Loading...',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildItem(
              text: "Ubah Foto Profil",
              iconData: Icons.camera_alt,
              iconColor: const Color.fromARGB(255, 0, 0, 0),
              onClick: _pickImage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildItem(
              text: "Profile Saya",
              iconData: Icons.person,
              iconColor: const Color.fromARGB(255, 188, 0, 0),
              onClick: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfilePage();
                  },
                ));
              },
            ),
          ),
          SizedBox(height: 30),
          buildItemContent(
            text: "Pesan Tersimpan",
            iconData: Icons.bookmark,
            iconColor: const Color.fromARGB(255, 0, 150, 250),
          ),
          buildItemContent(
            text: "Panggilan Terakhir",
            iconData: Icons.call,
            iconColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          buildItemContent(
            text: "Perangkat",
            iconData: Icons.devices,
            iconColor: const Color.fromARGB(255, 141, 0, 162),
          ),
          buildItemContent(
            text: "Folder Obrolan",
            iconData: Icons.folder,
            iconColor: const Color.fromARGB(255, 147, 78, 0),
          ),
        ],
      ),
    );
  }
}
