// lib/widgets/sos_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSButton extends StatelessWidget {
  const SOSButton({Key? key}) : super(key: key);

  Future<void> _sendEmergencySMS() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? emergencyContact = prefs.getString('emergency_contact');
      
      if (emergencyContact == null || emergencyContact.isEmpty) {
        throw Exception('No emergency contact found');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String message = 'Emergency! I need help. My location is: '
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

      await sendSMS(message: message, recipients: [emergencyContact]);
    } catch (e) {
      print('Error sending emergency SMS: $e');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _sendEmergencySMS,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: const Text(
        'SOS',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}