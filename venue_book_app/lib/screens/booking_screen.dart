import 'package:flutter/material.dart';
import '../services/data_service.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final venue = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text("Confirm Booking")),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(venue['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Capacity: ${venue['capacity']}"),
          Text("Price: ${venue['price']}"),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () async {
                final ds = DataService();
                ds.bookings.add({
                  "user": "guest",
                  "venue": venue['name'],
                  "capacity": venue['capacity'],
                  "price": venue['price']
                });
                await ds.saveBookings();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Booking confirmed for ${venue['name']}!")));
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: Text("Confirm Booking"))
        ]),
      ),
    );
  }
}
