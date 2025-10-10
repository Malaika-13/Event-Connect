import 'package:flutter/material.dart';
import '../services/data_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Admin")),
        body: ListView(
          children: [
            ListTile(title: Text("Bookings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ...ds.bookings
                .map((b) => ListTile(
                      title: Text("${b['user']} → ${b['venue']}"),
                      subtitle: Text("Capacity: ${b['capacity']} | ${b['price']}"),
                    ))
                ,
            Divider(),
            ListTile(title: Text("Venues", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ...ds.venues.keys.map((cat) => ExpansionTile(
                  title: Text(cat),
                  children: [
                    ...List<Widget>.from((ds.venues[cat] as List)
                        .map((v) => ListTile(
                              title: Text(v['name']),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      (ds.venues[cat] as List).removeWhere((x) => x['name'] == v['name']);
                                      ds.saveVenues();
                                    });
                                  }),
                            ))),
                    TextButton(
                        onPressed: () => _addVenuePopup(cat),
                        child: Text("Add Venue", style: TextStyle(color: Colors.teal)))
                  ],
                ))
          ],
        ));
  }

  void _addVenuePopup(String category) {
    final name = TextEditingController();
    final cap = TextEditingController();
    final price = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Add Venue ($category)"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: name, decoration: InputDecoration(labelText: 'Name')),
                TextField(controller: cap, decoration: InputDecoration(labelText: 'Capacity')),
                TextField(controller: price, decoration: InputDecoration(labelText: 'Price')),
              ]),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      (ds.venues[category] as List).add({
                        "name": name.text,
                        "capacity": cap.text,
                        "price": price.text
                      });
                      await ds.saveVenues();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text("Save"))
              ],
            ));
  }
}
