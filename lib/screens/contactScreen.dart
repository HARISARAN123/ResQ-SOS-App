import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading contacts'));
          }

          final prefs = snapshot.data!;
          String emergencyContact = prefs.getString('emergency_contact') ?? 'No emergency contact found';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Emergency Contact'),
                  subtitle: Text(emergencyContact),
                ),
                // You can add more contacts or functionality as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
