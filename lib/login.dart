import 'package:flutter/material.dart';
import 'contacts.dart'; // Halaman setelah login akan menuju halaman kontak

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _primaryColor = const Color.fromARGB(255, 128, 7, 7); // Default primary color
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Untuk validasi
  final _formKey = GlobalKey<FormState>();

  void _changeColor(Color color) {
    setState(() {
      _primaryColor = color;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil!\nUsername: $username\nPassword: $password'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactsPage()), // Setelah login, pindah ke halaman kontak
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
          actions: [
            PopupMenuButton<Color>(
              onSelected: _changeColor,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<Color>(
                    value: Color.fromARGB(255, 122, 5, 5),
                    child: Text("LINGTAN"),
                  ),
                  const PopupMenuItem<Color>(
                    value: Colors.blue,
                    child: Text("Blue"),
                  ),
                  const PopupMenuItem<Color>(
                    value: Colors.green,
                    child: Text("Green"),
                  ),
                  const PopupMenuItem<Color>(
                    value: Color.fromARGB(255, 133, 14, 6),
                    child: Text("Red"),
                  ),
                ];
              },
            ),
          ],
        ),
        body: SingleChildScrollView( // Supaya bisa di-scroll
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                Form(
                  key: _formKey, // Tambahkan form key untuk validasi
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
            fontSize: 24,
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
              borderSide: BorderSide.none
            ),
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
              borderSide: BorderSide.none
            ),
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
      child: const Text(
        "Forgot password?", 
        style: TextStyle(color: Colors.black)
      )
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {}, 
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black)
          )
        )
      ],
    );
  }
}
