import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contacts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _primaryColor = const Color.fromARGB(255, 128, 7, 7);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _changeColor(Color color) {
    setState(() {
      _primaryColor = color;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('username', username);
      sharedPreferences.setString('password', password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Login berhasil!\nUsername: $username\nPassword: $password'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("."),
          actions: [
            IconButton(
              icon: SizedBox(
                width: 30,
                height: 29,
                child: Image.asset('assets/warna.png'),
              ),
              onPressed: () => _showColorMenu(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                Form(
                  key: _formKey,
                  child: _inputField(context),
                ),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showColorMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem<Color>(
          value: Color.fromARGB(255, 161, 42, 34),
          child: const Text("LINGTAN"),
          onTap: () => _changeColor(Color.fromARGB(255, 161, 42, 34)),
        ),
        PopupMenuItem<Color>(
          value: const Color.fromARGB(255, 73, 3, 86),
          child: const Text("FTI"),
          onTap: () => _changeColor(const Color.fromARGB(255, 72, 4, 128)),
        ),
        PopupMenuItem<Color>(
          value: const Color.fromARGB(255, 59, 49, 49),
          child: const Text("Dark"),
          onTap: () => _changeColor(const Color.fromARGB(255, 42, 39, 39)),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/lin.png',
          width: 200,
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          "LINGTAN",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: _primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person, color: _primaryColor),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: _primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock, color: _primaryColor),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: const Text("Forgot password?",
            style: TextStyle(color: Colors.black)));
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {},
            child: const Text("Sign Up", style: TextStyle(color: Colors.black)))
      ],
    );
  }
}
