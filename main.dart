import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(EventConnectApp());

class EventConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventConnect',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginScreen(),
    );
  }
}

//==================== FILE SERVICE ====================
class StorageService {
  static Future<String> get _dir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _file(String name) async {
    final path = await _dir;
    return File('$path/$name');
  }

  static Future<Map<String, dynamic>> readJson(String name) async {
    final file = await _file(name);
    if (!await file.exists()) return {};
    final content = await file.readAsString();
    return jsonDecode(content);
  }

  static Future<void> writeJson(String name, dynamic data) async {
    final file = await _file(name);
    await file.writeAsString(jsonEncode(data));
  }
}

//==================== LOGIN SCREEN ====================
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> attemptLogin() async {
    final username = userController.text.trim();
    final password = passController.text.trim();

    if (username == "admin" && password == "admin123") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen()));
      return;
    }

    final users = await StorageService.readJson("users.json");
    if (users[username] == password) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(username: username)));
    } else {
      _showMessage("Invalid username or password!");
    }
  }

  void _showMessage(String msg) {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text("Message"), content: Text(msg)));
  }

  void openRegister() {
    String newUser = "";
    String newPass = "";
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Register New User"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(decoration: InputDecoration(labelText: "Username"), onChanged: (v) => newUser = v),
              TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true, onChanged: (v) => newPass = v),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    if (newUser.isEmpty || newPass.isEmpty) return;
                    final users = await StorageService.readJson("users.json");
                    if (users.containsKey(newUser)) {
                      _showMessage("User already exists!");
                      return;
                    }
                    users[newUser] = newPass;
                    await StorageService.writeJson("users.json", users);
                    Navigator.pop(context);
                    _showMessage("User registered successfully!");
                  },
                  child: Text("Register"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EventConnect Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(controller: userController, decoration: InputDecoration(labelText: "Username")),
          TextField(controller: passController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: attemptLogin, child: Text("Login")),
          TextButton(onPressed: openRegister, child: Text("Register New User"))
        ]),
      ),
    );
  }
}

//==================== HOME SCREEN ====================
class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({required this.username});

  final categories = ["Resorts", "Corporate Halls", "Banquets", "Marquees"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, $username")),
      body: ListView(
        children: categories
            .map((cat) => Card(
                  child: ListTile(
                    title: Text(cat),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CategoryScreen(category: cat, username: username))),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

//==================== CATEGORY SCREEN ====================
class CategoryScreen extends StatefulWidget {
  final String category;
  final String username;
  const CategoryScreen({required this.category, required this.username});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List venues = [];

  @override
  void initState() {
    super.initState();
    loadVenues();
  }

  Future<void> loadVenues() async {
    final data = await StorageService.readJson("venues.json");
    final defaultData = {
      "Resorts": [
        {"name": "Grand Hall", "capacity": 500, "price": "PKR 50,000"},
        {"name": "Open Garden", "capacity": 700, "price": "PKR 60,000"}
      ],
      "Corporate Halls": [
        {"name": "Sea Breeze", "capacity": 120, "price": "PKR 15,000"}
      ],
      "Banquets": [
        {"name": "Banquet Palace", "capacity": 300, "price": "PKR 35,000"}
      ],
      "Marquees": []
    };
    if (data.isEmpty) await StorageService.writeJson("venues.json", defaultData);
    setState(() {
      venues = (data[widget.category] ?? defaultData[widget.category]) ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: venues.isEmpty
            ? Center(child: Text("No venues found"))
            : ListView.builder(
                itemCount: venues.length,
                itemBuilder: (context, i) {
                  final v = venues[i];
                  return Card(
                    child: ListTile(
                      title: Text(v["name"]),
                      subtitle: Text("Capacity: ${v['capacity']} | ${v['price']}"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BookingScreen(
                                  venue: v, username: widget.username))),
                    ),
                  );
                }));
  }
}

//==================== BOOKING SCREEN ====================
class BookingScreen extends StatelessWidget {
  final Map venue;
  final String username;

  const BookingScreen({required this.venue, required this.username});

  Future<void> confirmBooking(BuildContext context) async {
    final bookings = await StorageService.readJson("bookings.json");
    final list = List<Map>.from(bookings["list"] ?? []);
    list.add({"user": username, "venue": venue["name"], "capacity": venue["capacity"], "price": venue["price"]});
    await StorageService.writeJson("bookings.json", {"list": list});
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Booking Confirmed"),
              content: Text("Your booking for ${venue['name']} is confirmed!"),
              actions: [
                ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: Text("OK"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(venue["name"])),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Capacity: ${venue["capacity"]}", style: TextStyle(fontSize: 18)),
          Text("Price: ${venue["price"]}", style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () => confirmBooking(context), child: Text("Confirm Booking"))
        ]),
      ),
    );
  }
}

//==================== ADMIN SCREEN ====================
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List bookings = [];
  Map venues = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final book = await StorageService.readJson("bookings.json");
    final ven = await StorageService.readJson("venues.json");
    setState(() {
      bookings = List<Map>.from(book["list"] ?? []);
      venues = ven;
    });
  }

  Future<void> addVenueDialog() async {
    String name = "", capacity = "", price = "", category = "";
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Add Venue"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(decoration: InputDecoration(labelText: "Name"), onChanged: (v) => name = v),
                TextField(decoration: InputDecoration(labelText: "Capacity"), onChanged: (v) => capacity = v),
                TextField(decoration: InputDecoration(labelText: "Price"), onChanged: (v) => price = v),
                TextField(decoration: InputDecoration(labelText: "Category (Resorts/Corporate Halls/Banquets/Marquees)"), onChanged: (v) => category = v),
              ]),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    if (name.isEmpty || category.isEmpty) return;
                    if (!venues.containsKey(category)) venues[category] = [];
                    venues[category].add({"name": name, "capacity": capacity, "price": price});
                    await StorageService.writeJson("venues.json", venues);
                    Navigator.pop(context);
                    loadData();
                  },
                  child: Text("Add"))
            ],
          );
        });
  }

  Future<void> clearBookings() async {
    await StorageService.writeJson("bookings.json", {"list": []});
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Admin Panel")),
        body: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Text("Bookings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...bookings.map((b) => ListTile(title: Text("${b["user"]}: ${b["venue"]} - ${b["price"]}"))),
            SizedBox(height: 20),
            Text("Venues", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...venues.entries.map((e) => ExpansionTile(
                  title: Text(e.key),
                  children: [
                    for (var v in e.value)
                      ListTile(
                          title: Text(v["name"]),
                          subtitle: Text("Cap: ${v["capacity"]}, Price: ${v["price"]}"))
                  ],
                )),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addVenueDialog, child: Text("Add Venue")),
            ElevatedButton(onPressed: clearBookings, child: Text("Clear All Bookings")),
          ],
        ));
  }
}

