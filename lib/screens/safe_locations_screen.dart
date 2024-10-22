// lib/screens/safe_locations_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SafeLocationsScreen extends StatefulWidget {
  const SafeLocationsScreen({super.key});

  @override
  _SafeLocationsScreenState createState() => _SafeLocationsScreenState();
}

class _SafeLocationsScreenState extends State<SafeLocationsScreen> {
  List<String> safeLocations = [];

  @override
  void initState() {
    super.initState();
    _loadSafeLocations();
  }

  Future<void> _loadSafeLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      safeLocations = prefs.getStringList('safe_locations') ?? [];
    });
  }

  Future<void> _addCurrentLocationAsSafe() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String location = "${position.latitude},${position.longitude}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    safeLocations.add(location);
    await prefs.setStringList('safe_locations', safeLocations);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Locations'),
      ),
      body: ListView.builder(
        itemCount: safeLocations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Safe Location ${index + 1}'),
            subtitle: Text(safeLocations[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                safeLocations.removeAt(index);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('safe_locations', safeLocations);
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCurrentLocationAsSafe,
        child: const Icon(Icons.add_location),
      ),
    );
  }
}