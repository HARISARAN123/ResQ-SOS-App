
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resq_ai/services/contact_service.dart';

class EmergencyService {
  final ContactService _contactService = ContactService();

  Future<void> sendEmergencySMS() async {
    List<Contact> emergencyContacts = await _contactService.getContacts();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String message = "I'm in danger! My location: "
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

    List<String> recipients =
        emergencyContacts.map((contact) => contact.phoneNumber).toList();

    await sendSMS(message: message, recipients: recipients);
  }

  Future<bool> isInSafeLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> safeLocations = prefs.getStringList('safe_locations') ?? [];

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (String safeLocation in safeLocations) {
      List<String> coordinates = safeLocation.split(',');
      double lat = double.parse(coordinates[0]);
      double lng = double.parse(coordinates[1]);

      double distance = Geolocator.distanceBetween(
          position.latitude, position.longitude, lat, lng);

      if (distance < 100) {  // Within 100 meters of a safe location
        return true;
      }
    }

    return false;
  }
}