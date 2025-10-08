import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  late Directory _dir;

  Map<String, dynamic> users = {};
  List<dynamic> bookings = [];
  Map<String, dynamic> venues = {};

  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();

    await _loadFile('users.json', _defaultUsers, (data) => users = data);
    await _loadFile('bookings.json', [], (data) => bookings = data);
    await _loadFile('venues.json', _defaultVenues, (data) => venues = data);
  }

  Future<void> _loadFile(String fileName, dynamic defaults, Function(dynamic) setter) async {
    final file = File('${_dir.path}/$fileName');

    if (!file.existsSync()) {
      try {
        final asset = await rootBundle.loadString('assets/$fileName');
        await file.writeAsString(asset.isNotEmpty ? asset : json.encode(defaults));
      } catch (e) {
        await file.writeAsString(json.encode(defaults));
      }
    }

    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      setter(defaults);
      await file.writeAsString(json.encode(defaults));
    } else {
      try {
        setter(json.decode(content));
      } catch (e) {
        setter(defaults);
        await file.writeAsString(json.encode(defaults));
      }
    }
  }

  Future<void> saveUsers() async => _save('users.json', users);
  Future<void> saveBookings() async => _save('bookings.json', bookings);
  Future<void> saveVenues() async => _save('venues.json', venues);

  Future<void> _save(String file, dynamic data) async {
    final f = File('${_dir.path}/$file');
    await f.writeAsString(json.encode(data));
  }

  Map<String, dynamic> get _defaultUsers => {};
  Map<String, dynamic> get _defaultVenues => {
        "Resorts": [
          {"name": "Grand Hall", "capacity": 500, "price": "PKR 50,000"},
          {"name": "Open Garden", "capacity": 700, "price": "PKR 60,000"}
        ],
        "Restaurants": [
          {"name": "Sea Breeze", "capacity": 120, "price": "PKR 15,000"}
        ],
        "Banquets": [
          {"name": "Banquet Palace", "capacity": 300, "price": "PKR 35,000"}
        ],
        "Beaches": []
      };
}
