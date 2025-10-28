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

  Future<void> _loadFile(
    String fileName,
    dynamic defaults,
    Function(dynamic) setter,
  ) async {
    final file = File('${_dir.path}/$fileName');

    if (!file.existsSync()) {
      try {
        final asset = await rootBundle.loadString('assets/$fileName');
        await file.writeAsString(
          asset.isNotEmpty ? asset : json.encode(defaults),
        );
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
      {"name": "Open Garden", "capacity": 700, "price": "PKR 60,000"},
    ],
    "Corporate Halls": [
      {"name": "Sea Breeze", "capacity": 120, "price": "PKR 15,000"},
    ],
    "Banquets": [
      {"name": "Banquet Palace", "capacity": 300, "price": "PKR 35,000"},
    ],
    "Marquees": [
      {
        "Marquee / Hall Name": "Area 51 Marquee",
        "Location": "DHA, Karachi (DHA listing)",
        "Seating Capacity": "500–800",
        "Category": "Upper-class / Middle-Upper",
        "Facilities / Amenities": "AC, décor options, stage, bridal room",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "The Clifton Marquee / Clifton Banquet",
        "Location": "Clifton (Teen Talwar / Clifton area)",
        "Seating Capacity": "450–600",
        "Category": "Middle-class",
        "Facilities / Amenities": "AC, banquet setup, décor",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Sunset Club Banquet & Garden",
        "Location": "Khayaban-e-Jami / DHA (Sunset Club grounds)",
        "Seating Capacity": "300–1000+",
        "Category": "Upper-class",
        "Facilities / Amenities":
            "Lawns, banquet halls, AC, parking, generator",
        "Pictures / Videos": "Photos on club page/listing",
      },
      {
        "Marquee / Hall Name": "Royal Marquee (Korangi)",
        "Location": "Korangi Road / Korangi area",
        "Seating Capacity": "1000–1800",
        "Category": "Upper-class",
        "Facilities / Amenities": "Large hall, stage, décor packages",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Grand Convention Banquet",
        "Location": "Korangi",
        "Seating Capacity": "600",
        "Category": "Middle-Upper",
        "Facilities / Amenities": "AC, stage, seating",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "La Grande Marquee",
        "Location": "Rashid Minhas Road / Block 21",
        "Seating Capacity": "400–700",
        "Category": "Middle-class",
        "Facilities / Amenities": "Bridal room, seating, décor",
        "Pictures / Videos": "Photos on Facebook listing",
      },
      {
        "Marquee / Hall Name": "Drive Inn Marquees",
        "Location": "Main Rashid Minhas Road",
        "Seating Capacity": "300–1000",
        "Category": "Middle to Upper",
        "Facilities / Amenities": "Virtual tours, décor, AC, staging",
        "Pictures / Videos": "Virtual tour link",
      },
      {
        "Marquee / Hall Name": "The Venue Banquet",
        "Location": "Rashid Minhas Road / Gulistan-e-Johar",
        "Seating Capacity": "500–1000",
        "Category": "Upper-class / Middle-upper",
        "Facilities / Amenities": "AC, ballroom-style, bridal room",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Akacia Banquet",
        "Location": "Shahrah-e-Faisal / central Karachi",
        "Seating Capacity": "700–800",
        "Category": "Upper-class",
        "Facilities / Amenities": "AC, ballroom, parking",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "City Banquet",
        "Location": "SMCHS / opposite CDC Bridge, Shahrah-e-Faisal",
        "Seating Capacity": "500–1000",
        "Category": "Upper-class",
        "Facilities / Amenities": "Large banquet, generator backup, parking",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Oasis Banquet",
        "Location": "Karachi (VenueBazaar / D7 listings)",
        "Seating Capacity": "400–700",
        "Category": "Middle to Upper",
        "Facilities / Amenities": "AC, décor options",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "CASAMENTO Banquet",
        "Location": "Karachi (VenueBazaar listing)",
        "Seating Capacity": "600",
        "Category": "Upper-class",
        "Facilities / Amenities": "Ballroom, décor packages",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Al-Mehmil Banquet",
        "Location": "Karachi (VenueBazaar listing)",
        "Seating Capacity": "200–700",
        "Category": "Lower to Upper",
        "Facilities / Amenities": "AC, stage, parking",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Bella Vista Banquet",
        "Location": "Karachi (D7 listing)",
        "Seating Capacity": "400–700",
        "Category": "Middle-class",
        "Facilities / Amenities": "AC, seating, parking",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Prestige Ballroom",
        "Location": "Karachi (D7 listing)",
        "Seating Capacity": "600–900",
        "Category": "Upper-class",
        "Facilities / Amenities": "Ballroom, AC, décor packages",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Arena — The Jade Hall",
        "Location": "Karachi (D7 listing)",
        "Seating Capacity": "600–900",
        "Category": "Upper-class",
        "Facilities / Amenities": "Large seating, stage, décor",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Glass Drive-In Marquee",
        "Location": "Karachi (ShaadiHall listing)",
        "Seating Capacity": "400–800",
        "Category": "Middle to Upper",
        "Facilities / Amenities": "Luxury décor, stage, bridal room",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Hamra’s Marquee",
        "Location": "Gulistan-e-Johar",
        "Seating Capacity": "500–700",
        "Category": "Middle-class / Upper",
        "Facilities / Amenities": "AC, décor, staging",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "The Region Banquets",
        "Location": "Clifton",
        "Seating Capacity": "120–500",
        "Category": "Middle-class",
        "Facilities / Amenities": "AC, private rooms, banquet seating",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Radisson / Marriott / Avari Hotels",
        "Location": "Clifton / DHA / City hotels",
        "Seating Capacity": "600–1200+",
        "Category": "Upper-class",
        "Facilities / Amenities":
            "Hotel ballrooms, valet, bridal suites, catering",
        "Pictures / Videos": "Photos on hotel sites",
      },
      {
        "Marquee / Hall Name": "Function Hall DHA",
        "Location": "DHA (Function Hall listing)",
        "Seating Capacity": "300–600",
        "Category": "Middle-class",
        "Facilities / Amenities": "AC, banquet seating",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "The Imperial Marquees",
        "Location": "Karachi (Instagram / listing)",
        "Seating Capacity": "500+",
        "Category": "Upper-class",
        "Facilities / Amenities": "Décor, staging, bridal room",
        "Pictures / Videos": "Instagram reels/photos",
      },
      {
        "Marquee / Hall Name": "Grand Marquee (Korangi Road)",
        "Location": "Korangi Road, near NICL Building",
        "Seating Capacity": "800–1500",
        "Category": "Upper-class",
        "Facilities / Amenities": "Large marquee, staging, parking",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "La Glamour / La Grande variants",
        "Location": "Various Karachi locations",
        "Seating Capacity": "400–900",
        "Category": "Middle to Upper",
        "Facilities / Amenities": "Bridal room, décor, AC",
        "Pictures / Videos": "Photos on listing",
      },
      {
        "Marquee / Hall Name": "Aggregator Venues (MallOfEvents / Marcem)",
        "Location": "Multiple Karachi addresses",
        "Seating Capacity": "200–1500",
        "Category": "Mixed",
        "Facilities / Amenities": "Varies per venue",
        "Pictures / Videos": "Photos on aggregator pages",
      },
    ],
  };
}
