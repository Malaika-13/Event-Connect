import 'package:flutter/material.dart';
import '../services/data_service.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    final venues = DataService().venues[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (_, i) {
          final v = venues[i];
          return ListTile(
            title: Text(v['name']),
            subtitle: Text("Capacity: ${v['capacity']} | ${v['price']}"),
            onTap: () => Navigator.pushNamed(context, '/booking', arguments: v),
          );
        },
      ),
    );
  }
}
