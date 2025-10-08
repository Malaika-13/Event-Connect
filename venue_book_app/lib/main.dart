import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/admin_screen.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().init();
  runApp(VenueBookApp());
}

class VenueBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Booking',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(),
        '/category': (_) => CategoryScreen(),
        '/booking': (_) => BookingScreen(),
        '/admin': (_) => AdminScreen(),
      },
    );
  }
}
