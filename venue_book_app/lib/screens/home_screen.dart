import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ["Resorts", "Restaurants", "Banquets", "Beaches"];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20),
        children: categories
            .map((cat) => GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/category', arguments: cat),
                  child: Card(
                    color: Colors.teal,
                    child: Center(child: Text(cat, style: TextStyle(fontSize: 20))),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
