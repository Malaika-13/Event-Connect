import 'package:flutter/material.dart';
import '../services/data_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _login() async {
    final ds = DataService();
    final user = _username.text.trim();
    final pass = _password.text.trim();

    if (user == "admin" && pass == "admin123") {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    if (ds.users[user] == pass) {
      Navigator.pushReplacementNamed(context, '/home', arguments: user);
    } else {
      _showMsg("Invalid username or password!");
    }
  }

  void _registerPopup() {
    final name = TextEditingController();
    final pass = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Register New User"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: name, decoration: InputDecoration(labelText: 'Username')),
                TextField(controller: pass, decoration: InputDecoration(labelText: 'Password')),
              ]),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      if (name.text.isEmpty || pass.text.isEmpty) return;
                      final ds = DataService();
                      if (ds.users.containsKey(name.text)) {
                        _showMsg("User already exists!");
                      } else {
                        ds.users[name.text] = pass.text;
                        await ds.saveUsers();
                        _showMsg("User registered successfully!");
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Register"))
              ],
            ));
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(controller: _username, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            TextButton(onPressed: _registerPopup, child: Text("Register")),
          ]),
        ));
  }
}
