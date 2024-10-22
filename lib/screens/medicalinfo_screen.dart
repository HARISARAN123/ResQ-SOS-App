import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalInfoScreen extends StatelessWidget {
  const MedicalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Information')),
      body: FutureBuilder(
        future: _getMedicalInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          final medicalInfo = snapshot.data as Map<String, String>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('Name: ${medicalInfo['name']}', style: const TextStyle(fontSize: 18)),
                Text('Age: ${medicalInfo['age']}', style: const TextStyle(fontSize: 18)),
                Text('Medical Conditions: ${medicalInfo['medical_conditions']}', style: const TextStyle(fontSize: 18)),
                Text('Allergies: ${medicalInfo['allergies']}', style: const TextStyle(fontSize: 18)),
                Text('Emergency Contact: ${medicalInfo['emergency_contact']}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, String>> _getMedicalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'N/A',
      'age': prefs.getString('age') ?? 'N/A',
      'medical_conditions': prefs.getString('medical_conditions') ?? 'N/A',
      'allergies': prefs.getString('allergies') ?? 'N/A',
      'emergency_contact': prefs.getString('emergency_contact') ?? 'N/A',
    };
  }
}
