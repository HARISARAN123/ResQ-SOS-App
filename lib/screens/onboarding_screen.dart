import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to ResQ SOS')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(labelText: 'Medical Conditions'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your medical conditions';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your allergies';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(labelText: 'Emergency Contact'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your emergency contact';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveDataAndNavigate,
              child: const Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDataAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', _nameController.text);
      prefs.setString('age', _ageController.text);
      prefs.setString('medical_conditions', _medicalConditionsController.text);
      prefs.setString('allergies', _allergiesController.text);
      prefs.setString('emergency_contact', _emergencyContactController.text);
      
      prefs.setBool('first_time', false);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}